Template.metaData.events
  
  'submit .imdbUpdate': ->
    event.preventDefault()
    imdbId = $(event.target).find('input[name=imdb_id]').val()
    Meteor.call('updateMetaData', imdbId, this.toString())

