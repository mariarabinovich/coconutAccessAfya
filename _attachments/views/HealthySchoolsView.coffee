class HealthySchoolsView extends Backbone.View

  el: '#constantbuttons'


  events:
    "click #addHealthySchoolsClient" : "addHSClient"



  render: =>
    @$el.html "
    <button id='addHealthySchoolsClient' type='button'>Add New Healthy Schools Client</button>



    <p>
    1- trigger the ability to add a client or search for one. . . register new kid or search for a child<br>
    2- make a new form for registering kids. with schools field of autocomplete<br>
    3- make a new followup form for healthy schools kids, with schools and name fields prefilled and uneditable<br>
    4- make sure datapoints that are the same as adults are called the same thing (data consistency)<br>
    5- make the child dashboard for a preregistered kid - client info<br>
      this will be the healthi schools forms i guess with a button at the end that will trigger a new registration or a client search.

      </p>
    "
    # $("input").textinput()
    # $("head title").html "Coconut Find/Create Client"

  addHSClient: ->
    schoolName = @lastSchoolNameUsed
    Coconut.router.navigate("/new/result/Healthy Schools/#{schoolName}",true)

    $("html, body").animate
        scrollTop: $('#top-menu').offset().top


    menu = $('.main-nav')
    burgerbutton = $('.menuburger')
    menu.removeClass("open")
    menu.css('display','none')
    burgerbutton.removeClass("menuisopen", "slow")




        # Coconut.loginView.callback =
        #   success: ->
        #     $("head title").html "Coconut"
        #     Coconut.router.navigate("/summary/#{client1}",true)
        # Coconut.loginView.render()



