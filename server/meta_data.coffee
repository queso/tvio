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
    fetchMetaData(mediaFile) unless data

fetchMetaData = (mediaFile) ->
  name = mediaFile.name
  categoryName = Categories.findOne(_id: mediaFile.categoryId).folder
  results = Meteor.http.get('http://www.omdbapi.com/', {params: {t: name, r: 'JSON', tomatoes: true}})
  content = JSON.parse(results['content'])
  url = content['Poster']
  image = downloadImage(url, name, categoryName) if url
  genres = content['Genre'].split(", ") if content['Genre']
  tomatoMeter = content['tomatoMeter']
  tomatoImage = content['tomatoImage']
  doc = {name: name, image: image, genres: genres, tomatoMeter: tomatoMeter, tomatoImage: tomatoImage}
  MetaData.insert(doc)

downloadImage = (url, name, category) ->
  console.log "Handling image download for #{name}: #{url}"
  fut = new Future()
  request.get {url: url, encoding: null}, (error, result, body) ->
    if error then return console.error error
    string = new Buffer(body, 'binary')
    path = "images/#{category}/#{name}.jpg"
    fs.writeFileSync("public/#{path}", string, {encoding: 'binary'})
    fut.ret path
  file = fut.wait()

Meteor.startup ->
  console.log('Starting metadata scanning')
  Meteor.setInterval(checkForMetaData, 5000)

