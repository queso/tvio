Meteor.methods
  updateMetaData: (imdbId, name) ->
    data = MetaData.findOne({name: name})
    results = Meteor.http.get('http://www.omdbapi.com/', {params: {i: imdbId, r: 'JSON'}})
    content = JSON.parse(results['content'])
    doc = {name: name, image: content['Poster'], genres: content['Genre'].split(", ")}
    MetaData.update(data._id, {$set: doc}) 

checkForMetaData = ->
  MediaFiles.find().forEach (mediaFile) ->
    data = MetaData.findOne({name: mediaFile.name})
    fetchMetaData(mediaFile.name) unless data

fetchMetaData = (name) ->
  results = Meteor.http.get('http://www.omdbapi.com/', {params: {t: name, r: 'JSON'}})
  content = JSON.parse(results['content'])
  doc = {name: name, image: content['Poster'], genres: content['Genre'].split(", ")}
  MetaData.insert(doc)

Meteor.startup ->
  console.log('Starting metadata scanning')
  Meteor.setInterval(checkForMetaData, 2000)

