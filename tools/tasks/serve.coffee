# # `serve`
#
# Starts a web server which serves files from the configured
# `config.path.target` directory.

browserSync = require 'browser-sync'
gulp        = require('gulp-help')(require 'gulp')



# @param {Object} config - Build configuration file.

module.exports = (config) ->

  gulp.task 'serve', 'Serve jig files.', (done) ->
    browserSync
      files: config.path.jig
      logLevel: 'silent'
      notify: false
      open: 'local'
      port: config.serve.port.jig
      codeSync: true
      server:
        baseDir: config.path.jig
      ui: false
    , done
