class ClientSearchView extends Backbone.View

  el: '#content'

  events:
    "keyup .client"   : "onChange"
    "click #addClient" : "addClient"


  render: =>
    @$el.html "


      <div class='aa-header' data-role='header'>
        <h1>Find/Create Client</h1>
      </div>
      <span id='feedback'></span>
      <br>
      <div>
        <label for='client_1'>Client Last Name</label>
        <input class='client' id='client_1' type='text' name='clientlastname'>
      </div>
      <div id='results'></div>





    "
    # $("input").textinput()
    $("head title").html "Coconut Find/Create Client"




  onChange: ->

    # || '' catches the case when the form has already been
    # submitted due to the enter key being pressed

    menu = $('.main-nav')
    burgerbutton = $('.menuburger')
    menu.removeClass("open")
    menu.css('display','none')
    burgerbutton.removeClass("menuisopen", "slow")


    client1 = ($("#client_1").val() || '').toUpperCase()
    console.log(client1)
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
            <h1>RESULTS</h1>
            <a href='#{sortbythis?}' class='clientresult' >
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
              </a>

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

            <h3>don't see your client?</h3>


            <button id='addClient' type='button'>add new client</button>

            "
  addClient: ->
    lastName = ($("#client_1").val() || '').toUpperCase()
    Coconut.router.navigate("/new/result/Client Registration/#{lastName}",true)



        # Coconut.loginView.callback =
        #   success: ->
        #     $("head title").html "Coconut"
        #     Coconut.router.navigate("/summary/#{client1}",true)
        # Coconut.loginView.render()






