class MenuView extends Backbone.View

  el: '.main_header'

  events:
    "change" : "render"
    "click .menuburger" : "openOrCloseMenu"
    # "click #content" : "closeMenu"

  openOrCloseMenu: ->
    menu = $('.main-nav')
    thisbutton = $('.menuburger')
    theheader = $('.aa-header')
    menu.toggleClass("open")
    menu.slideToggle("slow")
    thisbutton.toggleClass("menuisopen", "slow")

# THIS DOESNT WORK< BUT WOULD BE COOL IF WORKED IN THIS VIEW TO ALWAYS CLOSE THE MENU (right now i'm closing it in different views)
  # closeMenu: ->
  #   menu = $('.main-nav')
  #   burgerbutton = $('.menuburger')
  #   menu.removeClass("open")
  #   menu.css('display','none')
  #   burgerbutton.removeClass("menuisopen", "slow")

  render: =>
    # @$el.html "
    #   <div id='navbar' data-role='navbar'>
    #     <ul></ul>
    #   </div>
    # "


    # the following  through $("[data-role=footer]").navbar() is moved from app.coffee i think this breaks some of the functions, like knowing when it was last synced
    adminButtons = "
      <a href='#login'>Login</a>
      <a href='#logout'>Logout</a>
      <a id='reports' href='#reports'>Reports</a>
      <a id='manage-button' href='#manage'>Manage</a>
      &nbsp;
    " if atServer()
    syncButton = "
      <a href='#sync/send_and_get'>Sync <span class='tinyfont'>(last done: <span class='sync-sent-and-get-status'></span>)</span></a>
    " if "mobile" is Coconut.config.local.get("mode")



    @$el.html "
      <button class='menuburger'></button>

        <nav class='main-nav closed'>
          <a href='#'><span>Find/Add Client</span></a>
          <a href='#'><span>Healthy Schools Intake</span></a>
          <a href='#'><span>Reports</span></a>
          <a href='#'><span>Feedback</span></a>
          <a href='index.html#logout'><span id='user'>Username / </span><span> logout</span></a>

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




