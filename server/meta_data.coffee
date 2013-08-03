fs = Npm.require('fs')
Future = Npm.require("fibers/future")
request = Npm.require('request')

Meteor.methods
  updateMetaData: (imdbId, name) ->
    data = MetaData.findOne({name: name})
    results = Meteor.http.get('http://www.omdbapi.com/', {params: {i: imdbId, r: 'JSON'}})
    content = JSON.parse(results['content'])
    image = downloadImage(content['Poster'], name)
    doc = {name: name, image: image, genres: content['Genre'].split(", ")}
    MetaData.update(data._id, {$set: doc}) 

checkForMetaData = ->
  MediaFiles.find().forEach (mediaFile) ->
    data = MetaData.findOne({name: mediaFile.name})
    fetchMetaData(mediaFile.name) unless data

fetchMetaData = (name) ->
  results = Meteor.http.get('http://www.omdbapi.com/', {params: {t: name, r: 'JSON'}})
  content = JSON.parse(results['content'])
  url = content['Poster']
  image = downloadImage(url, name)
  genres = content['Genre'].split(", ") if content['Genre']
  doc = {name: name, image: image, genres: genres }
  MetaData.insert(doc)

downloadImage = (url, name) ->
  console.log "Handling image download"
  fut = new Future()
  request.get {url: url, encoding: null}, (error, result, body) ->
    if error then return console.error error
    base64prefix = "data:" + result.headers["content-type"] + ";base64,"
    string = new Buffer(body, 'binary').toString('base64')
    image = base64prefix + string
    fut.ret image
  file = fut.wait()

Meteor.startup ->
  console.log('Starting metadata scanning')
  Meteor.setInterval(checkForMetaData, 5000)

