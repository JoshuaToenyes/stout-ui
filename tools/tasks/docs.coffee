# # `docs:dev`
#
# Starts documentation tasks for serving documentation and watching source files
# for changes. This task is ideal for developing and watching documentation
# simultaneously.

browserSync = require 'browser-sync'
gulp        = require('gulp-help')(require 'gulp')
shell       = require 'gulp-shell'
targets     = require '../helpers/target-dirs'


module.exports = (config, options) ->

  priv = if options.private then '--private' else ''

  gulp.task 'docs:generate', false, shell.task [
    "jsdoc #{priv} -d ./#{config.path.doc}/ -c .jsdoc.conf.json -t ./node_modules/ink-docstrap/template -R README.md -r"
  ]

  gulp.task 'docs', 'Generate documentation.', ['docs:generate'], (done) ->
    tpath = config.path.target
    targets = "#{tpath}/#{target}/**/*.js" for target in targets(config)

    if options.serve
      browserSync
        logLevel: 'silent'
        notify: false
        open: 'local'
        port: config.serve.port.docs
        files: config.path.doc + '/*'
        server:
          baseDir: config.path.doc
        ui: false
      , done
    else
      done()
  , {
    options:
      'serve':   'Generate and serve documentation on localhost.'
      'private': 'Include documentation for private member.'
  }
