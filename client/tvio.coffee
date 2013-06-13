Meteor.subscribe('media_files')
Meteor.subscribe('devices')
Meteor.subscribe('categories')

Template.nav.helpers
  categories: ->
    Categories.find()
  deviceName: ->
    device = Devices.findOne({_id: Session.get('currentDeviceId')})
    if device
      device['name']
    else
      'Choose an apple tv'

Template.nav.events
  'click #device-menu a': (e) ->
    e.preventDefault()
    Session.set('currentDeviceId', e.target.dataset['deviceId'])
