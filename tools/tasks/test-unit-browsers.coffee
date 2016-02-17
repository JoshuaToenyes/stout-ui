# # `test:unit:browsers`
#
# Runs unit tests in locally installed browsers.

gulp  = require('gulp-help')(require 'gulp')
karma = require 'karma'




# @param {boolean} watch - `true` to watch for changes and re-run.

module.exports = (config, options) ->

  name = 'test:unit:browsers'
  description = 'Run unit tests in locally installed browsers.'

  gulp.task name, description, ['bundle:test'], (done) ->
    if options.watch
      gulp.watch [
        config.path.src.coffee + '/**/*.coffee'
        config.path.test.unit + '/**/*.coffee'
      ], [name]
    options =
      configFile: __dirname + '/../config/karma.conf.coffee'
      singleRun: true
    cb = -> done()
    new karma.Server(options, cb).start()
