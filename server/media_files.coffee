fs = Npm.require('fs')
path = Npm.require('path')
basepath = (path.resolve('.'))

scanCategories = ->
  Categories.find().forEach (category) ->
    parents = fs.readdirSync("#{basepath}/public/media~/#{category.folder}")
    clean_parents = _.reject parents, (f) ->
      f == ".DS_Store"
    clean_parents.forEach (parent) ->
      scanMediaFiles(category, parent)

scanMediaFiles = (category, parent_folder) ->
  scanPath = "#{basepath}/public/media~/#{category.folder}/#{parent_folder}"
  files = fs.readdirSync(scanPath)
  clean_files = _.reject files, (f) ->
    f == ".DS_Store"
  clean_files.forEach (file) ->
    insertOrUpdateMediaFile(file, category, parent_folder)

insertOrUpdateMediaFile = (file, category, name) ->
  file_path = "media~/#{category['folder']}/#{name}/#{file}"
  mediaFile = MediaFiles.findOne({path: file_path})
  regExp = /S(\d+)E(\d+)/gi
  match = regExp.exec(file)
  if match
    season = match[1]
    episode = match[2]
  doc = {path: file_path, categoryId: category._id, name: name, season: season, episode: episode}
  if mediaFile
    MediaFiles.update(mediaFile._id, {$set: doc})
  else
    MediaFiles.insert(doc) unless mediaFile

Meteor.startup ->
  console.log('Starting launch scanning')

  Meteor.setInterval(scanCategories, 2000)
