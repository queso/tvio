@Settings = new Meteor.Collection('settings')

if Meteor.isServer and Settings.find().count() is 0
  Settings.insert({webServer: "http://localhost/"})
