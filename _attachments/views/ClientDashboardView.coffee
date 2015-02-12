class ClientDashboardView extends Backbone.View

  el: '#clientDashboard'



  events:
    "change" : "render"
    # "change" : "updateClientInfo"


    # "click #content" : "closeMenu"

  # openOrCloseMenu: ->
  #   menu = $('.main-nav')
  #   thisbutton = $('.menuburger')
  #   theheader = $('.aa-header')
  #   menu.toggleClass("open")
  #   menu.slideToggle("slow")
  #   thisbutton.toggleClass("menuisopen", "slow")


  # updateClientInfo: ->


  render: =>
    clientInfo = "somestuff about the client"
    # alert clientInfo
    @$el.html "
      #{clientInfo}
      <div class='subheader'>
        <a class='manageActions' href='#'>Vitals (25%)</a> |
        <a class='manageActions selected' href='#'> selected one variable (78%)</a> |
        <a class='manageActions' href='#'>Maternal Visit (if female?)</a> |
        <a class='manageActions' href='#'>Order Labs</a> |
        <a class='manageActions' href='#'>Prescribe</a> |
        <a class='manageActions' href='#'>Clinician notes (0%)</a>
      </div>
      "
  update:->
    clientInfo = "theres new client info"
    @$el.html "
        #{clientInfo} and more stuff cause appended
      "
    alert "updated"






