Template.categories.helpers
  categories: ->
    Categories.find()

Template.categories.events
  'submit #categories': ->
    name_el = $(event.target).find('#name')
    name = name_el.val()
    folder_el = $(event.target).find('#folder')
    folder = folder_el.val()
    name_el.val('')
    folder_el.val('')
    doc = {name: name, folder: folder}
    Categories.insert(doc)
    Meteor.call('makeCategory', folder)
