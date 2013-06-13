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
  'click .media-file i.button': (e) ->
    deviceId = Session.get('currentDeviceId')
    mediaFileId = e.target.dataset['mediaFileId']
    console.log("calling play with mediaFileId: #{mediaFileId}")
    Meteor.call('play', mediaFileId, deviceId)

  'click .episodic': (e) ->

Template.episodicGroup.helpers
  
  episodicGroupMediaFiles: (name) ->
    MediaFiles.find({name: name})

Template.episodicGroupMediaFile.helpers
  
  icon: ->
    mediaFile = MediaFiles.find({_id: this._id})
    if mediaFile.state == "playing"
      "pause"
    else
      "play"

  progressClass: ->
    mediaFile = MediaFiles.find({_id: this._id})
    if mediaFile.state == "playing"
      "active"

  viewed: ->
    this.viewed_percentage > 0
