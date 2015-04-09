class LegacyInputView extends Backbone.View

  el: '#constantbuttons'


  events:
    "click #addNewRecord" : "addRecord"



  render: =>
    @$el.html "
    <button id='addNewRecord' type='button'>Add New Legacy Record</button>




    "
    # $("input").textinput()
    # $("head title").html "Coconut Find/Create Client"



  addRecord: ->
    lastName = "skdfj"
    Coconut.router.navigate("/new/result/Legacy Input/#{lastName}",true)

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



