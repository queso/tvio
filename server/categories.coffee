fs = Npm.require('fs')

Meteor.methods
  makeCategory: (folder) ->
    console.log "Making folders for #{folder}"
    fs.mkdirSync("public/images/#{folder}")
    fs.mkdirSync("public/media~/#{folder}")
