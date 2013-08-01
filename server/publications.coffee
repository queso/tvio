Meteor.publish 'media_files', ->
  MediaFiles.find()

Meteor.publish 'categories', ->
  Categories.find()

Meteor.publish 'devices', ->
  Devices.find()

Meteor.publish 'meta_data', ->
  MetaData.find()

Meteor.publish 'settings', ->
  Settings.find()
