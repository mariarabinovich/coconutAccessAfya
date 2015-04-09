class ClientSearchView extends Backbone.View

  el: '#content'

  events:
    "keyup .client"   : "onChange"
    "click #addClient" : "addClient"



  render: =>

    @$el.html "



      <span id='feedback'></span>
      <br>
      <div class='aSection'>
        <label for='client_1'>Client Last Name</label>
        <input class='client' id='client_1' type='text' name='clientlastname'>
      </div>
      <div id='results'></div>


    "
    #$('#constantbuttons').height(10).css({visibility:0})
    # $("input").textinput()
    # $("head title").html "Coconut Find/Create Client"




  onChange: ->

    # || '' catches the case when the form has already been
    # submitted due to the enter key being pressed

    menu = $('.main-nav')
    burgerbutton = $('.menuburger')
    menu.removeClass("open")
    menu.css('display','none')
    burgerbutton.removeClass("menuisopen", "slow")


    client1 = ($("#client_1").val() || '').toUpperCase()
    #console.log(client1)
    if client1.length == 0
      $("#results").html ""
    else
      $("#client_1").val(client1)
      # search
      $.couch.db(Coconut.config.database_name()).view "#{Coconut.config.design_doc_name()}/clientsByLastName",
        startkey: client1
        endkey:client1+"z"
        include_docs: false
        error: (error) ->
          console.error "Error finding clients: " + JSON.stringify error
        success: (result) ->
          # console.log(result)
          results=_(result.rows).map (row) ->
            row.value
          $("#results").html "

            <!--- <a href='#{sortbythis?}' class='clientresult' > -->
            <div class='clientresult' >
                <div class='resultblocks title'>
                  <p class='resulttext'> Last name </p>
                </div>
                <div class='resultblocks title'>
                  <p class='resulttext'> First name </p>
                </div>
                <div class='resultblocks title'>
                  <p class='resulttext'> Other names </p>
                </div>
                <div class='resultblocks title'>
                  <p class='resulttext'> Phone number </p>
                </div>
            </div>
            <!---  </a> -->

            #{
            _(results).map (result) ->
              "
              <a href='#summary/#{result.id}' class='clientresult' >
                <div class='resultblocks'>
                  <p class='resulttext'> #{result.last_name} </p>
                </div>
                <div class='resultblocks'>
                  <p class='resulttext'> #{result.first_name} </p>
                </div>
                <div class='resultblocks'>
                  <p class='resulttext'> #{result.other_names} </p>
                </div>
                <div class='resultblocks'>
                  <p class='resulttext'> #{result.phone} </p>
                </div>
              </a>
              "

            .join("")
            }



            <button id='addClient' type='button'>add new client</button>












            "
        # $(".chosen-select").chosen()
  addClient: ->
    lastName = ($("#client_1").val() || '').toUpperCase()
    $("html, body").animate
        scrollTop: $('#top-menu').offset().top
    Coconut.router.navigate("/new/result/Client Registration/#{lastName}",true)

    Coconut.isItANewPerson = true
    #the above variable was set to let questionView displavi a 'start new ysit button. The better wav y to do this will be to have question yew recognize when it is "registration" and just displavi the button then'
    #$('#constantbuttons').html "

    #@$el.append "
      #<a class='buttonLinks ' id='startTheVisit'  onclick = 'startVisit()' >
        #  New clinical visit</a>"





    #Coconut.menuView.renderForClientVisit(@client)
    #document.location.href = "#new/result/Vitals/#{@client.clientID}"



        # Coconut.loginView.callback =
        #   success: ->
        #     $("head title").html "Coconut"
        #     Coconut.router.navigate("/summary/#{client1}",true)
        # Coconut.loginView.render()






