# # `serve`
#
# Starts a web server which serves files from the configured
# `config.path.target` directory.

browserSync = require 'browser-sync'
gulp        = require('gulp-help')(require 'gulp')



# @param {Object} config - Build configuration file.

module.exports = (config) ->

  gulp.task 'serve:example', 'Serve example files.', (done) ->
    browserSync
      files: config.path.target.example
      logLevel: 'silent'
      notify: false
      open: 'local'
      port: config.serve.port.target
      codeSync: false
      server:
        baseDir: config.path.target.example
      ui: false
    , done
