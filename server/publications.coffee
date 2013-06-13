Meteor.publish 'media_files', ->
  MediaFiles.find()

Meteor.publish 'categories', ->
  Categories.find()

Meteor.publish 'devices', ->
  Devices.find()
