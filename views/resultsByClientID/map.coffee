(document) ->
  if document.collection is "result"
    emit document.ClientID, null
