class SyncView extends Backbone.View
  initialize: ->
    @sync = new Sync()

  el: '#content'


        # <h2>Cloud Server: <span class='sync-target'>#{@sync.target()}</span></h2>

  render: =>
      @$el.html "

        <nav class='submenu'>
          <a href='#manage'>Question Sets</a>
          <a class='selected' href='#'>Sync</a>
          <a href='#configure'>Set cloud vs mobile</a>
          <a href='#users'>Manage users</a>
          <a href='#messaging'>Send message to users</a>
        </nav>
        <h2>Cloud Server: <span class='sync-target'>sync target text wasn't working</span></h2>
        <a class='buttonLinks' href='#sync/send'>Send data (last done: <span class='sync-sent-status'></span>)</a>
        <a class='buttonLinks' href='#sync/get'>Get data (last done: <span class='sync-get-status'></span>)</a>
        "
      $("a").button()
      @update()

  update: =>
    @sync.fetch
      success: =>
        $(".sync-sent-and-get-status").html @sync.last_get_time()
      # synclog doesn't exist yet, create it and re-render
      error: =>
        @sync.save()
        _.delay(@update,1000)

