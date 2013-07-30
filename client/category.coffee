Template.category.helpers
  mediaFiles: ->
    files = MediaFiles.find({categoryId: Session.get('currentCategoryId')}).fetch()

  episodicGroups: ->
    files = MediaFiles.find({categoryId: Session.get('currentCategoryId')}).fetch()
    names = _.pluck(files, 'name')
    _.uniq(names)

  isEpisodic: ->
    category = Categories.findOne({_id: Session.get('currentCategoryId')})
    category and category.episodic


Template.category.events
  'click .media-file i': ->
    deviceId = Session.get('currentDeviceId')
    Meteor.call('play', this._id, deviceId)

Template.mediaFile.helpers
  icon: ->
    if this.state == "playing"
      "pause"
    else
      "play"

Template.episodicGroup.events
  'click h3.episodic': ->
    $(event.target).siblings('table').first().toggleClass('hide')


Template.episodicGroup.helpers
  
  episodicGroupMediaFiles: (name) ->
    MediaFiles.find({name: name})

Template.episodicGroupMediaFile.helpers
  
  icon: ->
    if this.state == "playing"
      "pause"
    else
      "play"

  progressClass: ->
    if this.state == "playing"
      "active"

  viewed: ->
    this.viewed_percentage > 0
