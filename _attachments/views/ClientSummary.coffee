class ClientSummaryView extends Backbone.View
  el: '#content'
  # maybe later just stick this into .visitDashboard
  events:
    "click .startVisit" : "startVisit"
    "click .editClientInfo" : "editclientInfo"

  editclientInfo: =>
    console.log 'alskdfj'
    Coconut.menuView.renderForClientInfo(@client)
    document.location.href = "#edit/result/#{@client.clientID}"

  startVisit: =>
    Coconut.menuView.renderForClientVisit(@client)
    #Shrink the client summary table
    alert ('hi')
    $("html, body").animate
        scrollTop: $('#top-menu').offset().top
    document.location.href = "#new/result/Outpatient Visit/#{@client.clientID}"


  #changeQuestionSet: (newQuestionSet)=>
  #  document.location.href = newQuestionSet

  render: =>
    console.log @client

    Coconut.menuView.renderForClient(@client)






    @$el.html "
      <div class='aSection'>
      <table class='patientInfo'>
        <thead><th colspan='2' class = 'noteorhint'>Please check that this information is up to date</th></thead>
        <tbody>
        #{
          data = {

            # "Initial Visit Date" : @client.initialVisitDate()
            "Age"
            "Gender"
            "Allergies"
            "Known Issues"
            "Membership status"
            # "Age" : @client.clientName
            # "HIV Status" : @client.hivStatus()
            # "On ART" : @client.onArt()
            # "Last Blood Pressure" : @client.lastBloodPressure()
            # "Allergies" : @client.allergies()
            # "Complaints at Previous Visit" : @client.complaintsAtPreviousVisit()
            # "Treatment Given at Previous Visit" : @client.treatmentGivenAtPreviousVIsit()
          }
          _.map(data, (value, property) ->
            "
              <tr>
                <td>
                  #{property}
                </td>
                <td>
                  #{value}
                </td>
              </tr>
            "
          ).join("")
        }
        </tbody>
        <tfoot><th colspan='2'>
          <a class='buttonLinks editClientInfo' > Edit #{@client.firstName()}'s Info</a>
        </th></tfoot>
      </table>
      </div>





        <a class='buttonLinks startVisit' >
          New clinical visit for #{@client.firstName()}</a>

        <a class='buttonLinks startVisit' >
          Followup visit for #{@client.firstName()}</a>


          <div class='aSection'>
        <h2>Previous Visits/Forms</h2>
        #{
          _.map(@client.clientResultsSortedMostRecentFirst(), (result,index) =>
            date = result.createdAt || result.VisitDate || result.fDate
            question = result.question || result.source
            id = result._id || ""
            "
            <form class='previousVisitsList hideText'>
              <button class='fullwidthdropdown' onClick='$(\"#result-#{index}\").slideToggle(1000)' type='button'>#{question}: #{date}</button>
            </form>
            <div id='result-#{index}' class='aPreviousVisit' style='display: none'>
              #{@renderResult(result)}
              #{if result.question? then "
                <form class='hideText' method='get' action='#edit/result/#{id}'>
                  <button>Edit</button>
                </form>
              " else ""}
            </div>
            "
          ).join("")
        }
      </div>

    "
    $("button").button()

  renderResult: (result) =>
    "
      <table class='lastVisitResults'>
        <thead>
          <th>Property</th>
          <th>Value</th>
        </thead>
        <tbody>
          #{
            _.map result, (value, property) ->
              "
                <tr>
                  <td>
                    #{property}
                  </td>
                  <td>
                    #{value}
                  </td>
                </tr>
              "
            .join("")
          }
          <tr>
          </tr>
        </tbody>
      </table>
    "
