# # `docs:serve`
#
# Starts a web server which serves documentation files out of the configured
# docs folder (where the documentation files are generated), and opens the
# local web browser to view the documentation. The server will automatically
# reload pages as changes are made to the documentation files.

browserSync = require 'browser-sync'
gulp        = require('gulp-help')(require 'gulp')



module.exports = (config) ->

  gulp.task 'docs:serve', 'Serve documentation files locally.', [
    'docs:gen'], (done) ->
    browserSync
      logLevel: 'silent'
      notify: false
      open: 'local'
      port: config.serve.port.docs
      files: config.path.doc
      server:
        baseDir: config.path.doc
      ui: false
    , done
