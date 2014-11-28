(document) ->
  if document.question is "Client Registration"
    emit document.Lastname, {
      last_name: document.Lastname
      first_name: document.Firstname
      other_names: document.Othernames
      phone: document.Phonenumber
      id: document._id

    }

