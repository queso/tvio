Template.settings.events
  'submit #appSettings': ->
    event.preventDefault()
    setting = Settings.findOne()
    webServer = $(event.target).find('#webServer').val()
    doc = {webServer: webServer}
    if setting
      Settings.update(setting._id, {$set: doc})
    else
      Settings.insert(doc)

Template.settings.helpers
  webServer: ->
    Settings.findOne().webServer

