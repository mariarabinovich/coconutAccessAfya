class Client
  constructor: (options) ->
    @clientID = options?.clientID
    @loadFromResultDocs(options.results) if options?.results
    @availableQuestionTypes = []

  loadFromResultDocs: (resultDocs) ->
    @clientResults = resultDocs

    _.each resultDocs, (resultDoc) =>
      resultDoc = resultDoc.toJSON() if resultDoc.toJSON?

      if resultDoc.question
        @clientID ?= resultDoc.clientID
        @availableQuestionTypes.push resultDoc.question
        this[resultDoc.question] = [] unless this[resultDoc.question]?
        this[resultDoc.question].push resultDoc

    @availableQuestionTypes = _(@availableQuestionTypes).uniq()
    @sortResultArraysByCreatedAt()

  fetch: (options) ->
    $.couch.db(Coconut.config.database_name()).view "#{Coconut.config.design_doc_name()}/resultsByClientID",
      key: @clientID
      include_docs: true
      success: (result) =>
        @loadFromResultDocs(_.pluck(result.rows, "doc"))
        options?.success()
      error: (error) =>
        options?.error(error)

  toJSON: =>
    returnVal = {}
    _.each @availableQuestionTypes, (question) =>
      returnVal[question] = this[question]
    return returnVal

  name: =>
    @["Client Registration"][0].Firstname + " " + @["Client Registration"][0].Lastname

  firstName: =>
    @["Client Registration"][0].Firstname

#  phoneNumber  : =>
#    @["Client Registration"][0].Phonenumber

#  gender: =>
#    @["Client Registration"][0].Gender











  clientResultsSortedMostRecentFirst: () =>
    _(@clientResults).sortBy (result) ->
      result.fDate or result.VisitDate or result.lastModifiedAt
    .reverse()

  sortResultArraysByCreatedAt: () =>
    #TODO test with real data
    _.each @availableQuestionTypes, (resultType) =>
      @[resultType] = _.sortBy @[resultType], (result) ->
        result.createdAt


  flatten: (availableQuestionTypes = @availableQuestionTypes) ->
    returnVal = {}
    _.each availableQuestionTypes, (question) =>
      type = question
      _.each this[question], (value, field) ->
        if _.isObject value
          _.each value, (arrayValue, arrayField) ->
            returnVal["#{question}-#{field}: #{arrayField}"] = arrayValue
        else
          returnVal["#{question}:#{field}"] = value
    returnVal

  LastModifiedAt: ->
    _.chain(@toJSON())
    .map (question) ->
      question.lastModifiedAt
    .max (lastModifiedAt) ->
      lastModifiedAt?.replace(/[- :]/g,"")
    .value()

  Questions: ->
    _.keys(@toJSON()).join(", ")

  resultsAsArray: =>
    _.chain @possibleQuestions()
    .map (question) =>
      @[question]
    .flatten()
    .compact()
    .value()

  fetchResults: (options) =>
    results = _.map @resultsAsArray(), (result) =>
      returnVal = new Result()
      returnVal.id = result._id
      returnVal

    count = 0
    _.each results, (result) ->
      result.fetch
        success: ->
          count += 1
          options.success(results) if count >= results.length
    return results

  mostRecentValue: (resultType,question) =>
    returnVal = null
    if @[resultType]?
      sortedValues = _(@[resultType]).sortBy("lastModifiedAt").reverse()
      for result in sortedValues
        returnVal = result[question]
        break if returnVal? and returnVal != ""
    return returnVal

  allUniqueValues: (resultType, question, postProcess = null) =>
    if @[resultType]?
      _.chain(@[resultType])
      .map (result) ->
        if postProcess? and result[question]?
          postProcess(result[question])
        else
          result[question]
      .sort()
      .unique()
      .compact()
      .value()

  allQuestionsWithResult: (resultType, questions, resultToMatch, postProcess = null) ->
    if @[resultType]?
      _.chain(@[resultType])
      .map (result) ->
        _.map questions, (question) ->
          if result[question] is resultToMatch
            if postProcess?
              return postProcess(question)
            else
              return question
      .flatten()
      .sort()
      .unique()
      .compact()
      .value()

  allQuestionsWithYesResult: (resultType, questions, postProcess = null) ->
    @allQuestionsWithResult(resultType,questions,"Yes", postProcess)

  allQuestionsMatchingNameWithResult: (resultType, questionMatch, resultToMatch, postProcess = null) ->
    questions = _.chain(@[resultType])
      .map (result) ->
        _.map result, (answer,question) ->
          if question.match(questionMatch) and answer is resultToMatch
            if postProcess?
              return postProcess(question)
            else
              return question
      .flatten()
      .sort()
      .unique()
      .compact()
      .value()
    window.a = questions
    questions

  allQuestionsMatchingNameWithYesResult: (resultType, questionMatch, postProcess = null) ->
    @allQuestionsMatchingNameWithResult(resultType,questionMatch,"Yes", postProcess)

  allAnswersMatchingQuestionNameForResult: (result, questionMatch, postProcess = null) ->
    _.chain(result)
      .map( (answer,question) ->
        return answer if question.match(questionMatch)
      )
      .compact()
      .value()

  mostRecentClinicalVisit: ->
    if @["Clinical Visit"]?
      _.max(@["Clinical Visit"], (result) ->
        moment(result["createdAt"]).unix()
      )

  # calculateAge: (birthDate, onDate = new Date()) ->
  #     # From http://stackoverflow.com/questions/4060004/calculate-age-in-javascript
  #     age = onDate.getFullYear() - birthDate.getFullYear()
  #     currentMonth = onDate.getMonth() - birthDate.getMonth()
  #     age-- if (currentMonth < 0 or (currentMonth is 0 and onDate.getDate() < birthDate.getDate()))
  #     return age

  # currentAge: ->
  #   if @hasClientDemographics()
  #     yearOfBirth = @mostRecentValue("Client Demographics", "Whatisyouryearofbirth")
  #     monthOfBirth = @mostRecentValue("Client Demographics", "Whatisyourmonthofbirth")
  #     dayOfBirth = @mostRecentValue("Client Demographics", "Whatisyourdayofbirth")
  #     age = @mostRecentValue("Client Demographics", "Whatisyourage")

  #     if yearOfBirth?
  #       unless monthOfBirth?
  #         monthOfBirth = "June"
  #         dayOfBirth = "1"
  #       unless dayOfBirth?
  #         dayOfBirth = "15"
  #       return @calculateAge(new Date("#{yearOfBirth}-#{monthOfBirth}-#{dayOfBirth}"))
  #     else
  #       return age

  #   if @hasTblDemography()
  #     birthDate = @mostRecentValue "tblDemography", "DOB"
  #     if birthDate?
  #       return @calculateAge(new Date(birthDate))
  #     else
  #       #TODO calculate this based on date that age was recorded
  #       return @mostRecentValue "tblDemography", "Age"


  hasBeenRegistered: =>
    @["Client Registration"]?
