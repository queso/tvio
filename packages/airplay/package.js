Package.describe({
  summary: "Meteor smart package for airplay node.js package"
});

Npm.depends({
  "airplay": "0.0.3"
});

Package.on_use(function (api) {
  api.add_files("airplay.js", "server");
});
