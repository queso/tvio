root = exports ? this
airplay = Airplay.createBrowser()
started = airplay.start()

scanDevices = ->
  airplay.stop()
  devices = airplay.getDevices()
  root.DeviceList = devices
  devices.forEach (device) ->
    processDevice(device)
  removeUnfoundDevices(devices)

processDevice = (device) ->
  info = device["info_"]
  device = Devices.findOne({host: info['host']})
  if device
    Devices.update(device._id, {host: info['host'], name: info['name']})
  else
    Devices.insert({host: info['host'], name: info['name']})

removeUnfoundDevices = (devices) ->
  dbDevices = Devices.find().fetch()
  info = _.pluck(devices, 'info_')
  hosts = _.pluck(info, 'host')
  unfoundDevices = _.reject dbDevices, (device) ->
    _.contains(hosts, device.host)
  _.each unfoundDevices, (udevice) ->
    Devices.remove(udevice._id)

Meteor.startup ->
  Meteor.setInterval(scanDevices, 4000)
