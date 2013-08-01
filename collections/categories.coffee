@Categories = new Meteor.Collection('categories')

if Meteor.isServer and Categories.find().count() is 0
  categories = [
    name: "Tv Shows"
    folder: "tv-shows"
    episodic: true
  ,
    name: "Movies"
    folder: "movies"
    episodic: false
  ]

  _.each categories, (category) ->
    Categories.insert(category)
