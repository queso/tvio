root = exports ? this

Meteor.methods
  play: (mediaFileId, deviceId) ->
    airplay = Airplay.createBrowser()
    device = Devices.findOne({_id: deviceId})
    mediaFile = MediaFiles.findOne({_id: mediaFileId})
    ap_device = _.find DeviceList, (d) ->
      d['info_']['host'] == device['host']
    content = "http://10.0.1.201:81/#{encodeURI(mediaFile['path'])}"
    console.log("CONTENT: #{content}")
    ap_device.play content, 0
    monitorPlay(ap_device, mediaFile)

monitorPlay = (device, mediaFile) ->
  loading = true
  running = false
  MediaFiles.update(mediaFile._id, {$set: {state: "loading"}})
  while loading
    future = new Future()
    device.status (result) ->
      future.ret(result)
    res = future.wait()
    if res.duration > 0
      loading = false
      running = true
      MediaFiles.update(mediaFile._id, {$set: {state: "playing"}})
  while running
    future = new Future()
    device.status (result) ->
      future.ret(result)
    res = future.wait()
    if res.duration > 0
      percentage = new Number((res.position / res.duration)*100)
      MediaFiles.update(mediaFile._id, {$set: {viewed_percentage: percentage.toPrecision(3)}})
    else
      MediaFiles.update(mediaFile._id, {$set: {state: "finished"}})
      running = false

Meteor.startup ->
  root.Future = Npm.require('fibers/future')


