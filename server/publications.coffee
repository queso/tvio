Meteor.publish 'media_files', ->
  MediaFiles.find({}, {sort: [['name', 'ascending']]})

Meteor.publish 'categories', ->
  Categories.find({}, {sort: [['folder', 'ascending']]})

Meteor.publish 'devices', ->
  Devices.find({}, {sort: [['name', 'ascending']]})

Meteor.publish 'meta_data', ->
  MetaData.find()

Meteor.publish 'settings', ->
  Settings.find()
