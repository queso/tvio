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
  'click .play-button': ->
    deviceId = Session.get('currentDeviceId')
    Meteor.call('play', this._id, deviceId)

  'click .close-pageslide': ->
    event.preventDefault()
    $(event.target).parents('.pageslide').removeClass('active-pageslide')

  'click .pageslide-link': ->
    event.preventDefault()
    $("##{this._id}").toggleClass('active-pageslide')

Template.mediaFile.helpers
  icon: ->
    if this.state == "playing"
      "pause"
    else
      "play"

  image: ->
    data = MetaData.findOne({name: this.name})
    data.image if data

Template.episodicGroup.events
  'click .pageslide-link': ->
    event.preventDefault()
    name = this.split(" ").join("-").toLowerCase()
    $("##{name}").toggleClass('active-pageslide')

  'click .edit-metadata': ->
    $(event.target).parents('.pageslide').find('.metaDataForm').toggleClass('showMetaDataForm')
    $(event.target).parents('.pageslide').find('.metaDataForm').css('visibility: hidden;')

Template.episodicGroup.helpers
  
  episodicGroupMediaFiles: (name) ->
    MediaFiles.find({name: name}, {sort: [['season', 'ascending'], ['episode', 'ascending']]})

  className: (name) ->
    name.split(" ").join("-").toLowerCase()

  image: (name) ->
    data = MetaData.findOne({name: name})
    data.image

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
