class ManageView extends Backbone.View

  el: '#content'

  render: =>
    @$el.html "
    <nav class='submenu'>
      <a class='selected' href='#'>Question Sets</a>
      <a href='#sync'>Sync</a>
      <a href='#configure'>Set cloud vs mobile</a>
      <a href='#users'>Manage users</a>
      <a href='#messaging'>Send message to users</a>
    </nav>

      <h2>Question Sets</h2>
      <a class='buttonLinks' href='#design'>New</a>
      <table>
        <thead>
          <th></th>
          <th></th>
          <th></th>
          <th></th>
        </thead>
        <tbody>
        </tbody>
      </table>
    "
    $("a").button()
    Coconut.questions.fetch
      include_docs: true
      success: (result) ->
        Coconut.questions.each (question) ->
          questionName = question.id
          questionId = escape(question.id)
          $("tbody").append "
            <tr>
              <td>#{questionName}</td>
              <td><a href='#edit/#{questionId}'>edit</a></td>
              <!--<td><a href='#delete/#{questionId}'>delete</a></td>-->
              <td><a href='#edit/resultSummary/#{questionId}'>summary</a></td>
            </tr>
          "
        $("table a").button()
