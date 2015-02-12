class MenuView extends Backbone.View

  el: '.main_header'
  currentDate = new Date()
  days = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];
  dayOfTheWeek = currentDate.getDay()
  utcDate= days[dayOfTheWeek] + ' ' + (currentDate.getMonth()+ 1) + '/' + currentDate.getDate() + '/' + currentDate.getFullYear()



  events:
    "change" : "renderForNonClient" #is this correct..
    "click .menuburger" : "openOrCloseMenu"
    "click .menuitem" : "changeHeader"
    "click .aSection" : "openOrCloseMenu" #figure out the parentchild issue that makes this not work

    "click #backtoclientsearch" : "leaveClient" #from client summary

    "click #clientoptionsmenu" : "clientOptions"
    "click #stayinvisit" : "clientOptions"
    "click .exitvisit" : "leaveVisit"

    "click .questionSetName" :  "changeQuestionSet"


  changeQuestionSet : (event)=>
    target = $(event.target)
    newQuestionSet = target.closest("li").attr("href")
    Coconut.clientSummary.changeQuestionSet(newQuestionSet)
    target.closest("li").parent().find("li.selected").removeClass("selected")
    target.closest("li").addClass("selected")


  clientOptions: =>
    theclient=Coconut.clientSummary.client
    clientmenu = $('.clientmenu')
    clientmenu.toggleClass("visible")
    clientmenu.slideToggle("slow")



  leaveVisit: =>
    theclient=Coconut.clientSummary.client
    #alert "you are trying to leave this visit incomplete. please go back to the visit and use the COMPLETE VISIT tab to complete the visit"
    @renderForClient(theclient)
    document.location.href = "#summary/#{theclient.clientID}"

  leaveClient: =>
    #ask if you are sure you want to leave the client experience
    #OR make it impossible until you complete the why / end of visit questioneer
    #alert ('Are you sure you want to leave this visit, once you leave this visit you will not be able to edit visit details')
    @renderForNonClient()
    document.location.href = "#search/client"
    #and go back to search


  changeHeader: (event) ->
    #this whole thing can probably be inside of renderForNonClient, just check to make sure that it is never called when menu doesn't need to open or close
    target = $(event.target)
    newmenutitle = target.closest("a").attr("title")
    console.log newmenutitle
    $("div.header h1").html newmenutitle
    @openOrCloseMenu()




  openOrCloseMenu: ->
    menu = $('.main-nav')
    thisbutton = $('.menuburger')
    theheader = $('.aa-header')
    menu.toggleClass("open")
    menu.slideToggle("slow")
    thisbutton.toggleClass("menuisopen", "slow")

  renderForClientInfo: (client) =>
    @$el.html "
    <div class='header'>
      <button class='menuback exitvisit'></button>
        <h1>#{client.name()}</h1> <h4>EDIT CLIENT INFO</h4>
    </div>
    "

  renderForClientVisit: (client) =>
    scrolled_val = $(document).scrollTop().valueOf()
    console.log scrolled_val
    #<div class='header'>
    #  <button class='endTheVisit' id='clientoptionsmenu'></button>
    #    <div class='visitTitle'><h1>#{client.name()}</h1> <h4> #{utcDate}, Clinician: <span id='cliniciansName'></span></h4></div>
    #</div>

    @$el.html "
    <div class='header'>
      <button class='endTheVisit' id='clientoptionsmenu'></button>
    </div>

    <div class='clientmenu hidden'>
        <div class='visitTitle'><h1>#{client.name()}</h1> <h4> CURRENT VISIT:#{utcDate}, Clinician: <span id='cliniciansName'></span></h4></div>
        <table class='patientInfo'>
        <tbody>
        #{
          data = {
            "Age"
            "Gender"
            "Allergies"
            "Known Issues"
            "Membership status"
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
      </table>
      <a class='buttonLinks' id='stayinvisit'>Back to the visit  &gt;</a>
      <a class='buttonLinks exitvisit'>&lt; leave this visit</a>

    </div>

    <nav class='visitOptions'>
      <ul>
      <li class='questionSetName selected' href='#new/result/Vitals/#{client.clientID}'><img src='css/images/vitals.png' alt='vitals' class='visitOptionsIcons'></li>
      <li class='questionSetName ' href='#new/result/Complaints/#{client.clientID}'><img src='css/images/complaint.png' alt='complaint' class='visitOptionsIcons'></li>
      <li class='questionSetName ' href='#new/result/Labs/#{client.clientID}'><img src='css/images/labs.png' alt='labs'  class='visitOptionsIcons'></li>
      <li class='questionSetName ' href='#new/result/Diagnosis/#{client.clientID}'><img src='css/images/diagnose.png' alt='diagnose'  class='visitOptionsIcons'></li>
      <li class='questionSetName ' href='#new/result/Complete%20Visit/#{client.clientID}'><img src='css/images/complete.png' alt='complete' class='visitOptionsIcons'></li>

      </ul>
    </nav>
    "
      # test for COMPLETE BUTTON: <li class='questionSetName' href='#new/result/Clinical%20Visit/#{client.clientID}'  >Clinical</li>
       # put this back in the client options menu maybe:: <a class='buttonLinks exitvisit'>leave this visit</a>
  renderForClient: (client) =>
    # do stuff
    #change the burger to back button here
    console.log "hello"



    @$el.html "
    <div class='header'>
      <button class='menuback' id='backtoclientsearch' ></button>
        <div class='profileIconDiv'></div>
       <div class='clientTitle'> <h1>#{client.name()}</h1> </div>
    </div>
    "
    # $("div.header h1").html client.name()



  renderForNonClient: =>
    # the following  through $("[data-role=footer]").navbar() is moved from app.coffee i think this breaks some of the functions, like knowing when it was last synced
    adminButtons = "
      <a href='#login'>Login</a>
      <a href='#logout'>Logout</a>
      <a id='reports' href='#reports'>Reports</a>
      <a id='manage-button' href='#manage'>Manage</a>
      &nbsp;
    " if atServer()
      #change this
    syncButton = "
      <a href='#sync/send_and_get'>Sync <span class='tinyfont'>(last done: <span class='sync-sent-and-get-status'></span>)</span></a>
    " if "mobile" is Coconut.config.local.get("mode")



    @$el.html "
    <div class='header'>
      <button class='menuburger'></button>
        <h1>Find or Add Clients</h1>
    </div>

        <nav class='main-nav closed'>
          <a class='menuitem selected' title ='Find or Add Clients' href='#'><span>Find/Add Client</span></a>

          <a class='menuitem' title ='Reports' href='#reports'><span>Reports</span></a>
          <a class='menuitem' title ='Feedback' href='#help'><span>Feedback</span></a>
          <a class='menuitem' title ='System Admin' href='#manage'><span>Manage</span></a>
          <a class='menuitem' title ='Login logout' href='index.html#logout'><span id='user'>Username / </span><span> logout</span></a>

          #{syncButton || ''}
          #{adminButtons || ''}

        </nav>

      "

    @updateVersion()
    @checkReplicationStatus()

    Coconut.questions.fetch
      # success: =>

      #   @$el.find("ul").html "
      #     <li>
      #       <a id='menu-retrieve-client' href='#new/result'>
      #         <h2>Find/Create Client<div id='menu-partial-amount'>&nbsp;</div></h2>
      #       </a>
      #     </li> "
      #   @$el.find("ul").append(Coconut.questions.map (question,index) ->
      #     "<li><a id='menu-#{index}' class='menu-#{index}' href='#show/results/#{escape(question.id)}'><h2>#{question.id}<div id='menu-partial-amount'></div></h2></a></li>"
      #   .join(" "))
      #   $(".question-buttons").navbar()
      #   # disable form buttons
      #   Coconut.questions.each (question,index) -> $(".menu-#{index}").addClass('ui-disabled')
      #   @update()


  renderForHealthySchools: =>
    #back button
    #do stuff
  renderForLegacyRecords: =>
    #back button
    #do stuff if this is actually different: we probably will just have a form for legacy forms and at the end a NEXT option

  renderForAdmin: =>
    # do stuff






  updateVersion: ->
    $.ajax "version",
      success: (result) ->
        $("#version").html result
      error:
        $("#version").html "-"

  update: ->
    Coconut.questions.each (question,index) =>
      results = new ResultCollection()
      results.fetch
        include_docs: false
        question: question.id
        isComplete: true
        success: (results) =>
          $("#menu-#{index} #menu-partial-amount").html results.length

    @updateVersion()

  checkReplicationStatus: =>
    $.couch.login
      name: Coconut.config.get "local_couchdb_admin_username"
      password: Coconut.config.get "local_couchdb_admin_password"
      error: => console.log "Could not login"
      complete: =>
        $.ajax
          url: "/_active_tasks"
          dataType: 'json'
          success: (response) =>
            # This doesn't seem to work on Kindle - always get []. Works fine if I hit kindle from chrome on laptop. Go fig.
            progress = response?[0]?.progress
            if progress
              $("#databaseStatus").html "#{progress}% Complete"
              _.delay @checkReplicationStatus,1000
            else
              console.log "No database status update"
              $("#databaseStatus").html ""
              _.delay @checkReplicationStatus,60000
          error: (error) =>
            console.log "Could not check active_tasks: #{JSON.stringify(error)}"
            _.delay @checkReplicationStatus,60000




