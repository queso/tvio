Meteor.Router.add
  '/category/:id': (id) ->
    Session.set('currentCategoryId', id)
    'category'

  '/settings': 'settings'
