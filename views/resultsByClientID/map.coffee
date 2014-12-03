(document) ->
  if document.collection is "result"
    if document.ClientID
      emit document.ClientID, null
    if document.question is "Client Registration"
      emit document._id, null
