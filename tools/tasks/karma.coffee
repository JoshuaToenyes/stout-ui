# # `test:unit:browsers`
#
# Runs unit tests in locally installed browsers.

gulp  = require('gulp-help')(require 'gulp')
karma = require 'karma'




# @param {boolean} watch - `true` to watch for changes and re-run.

module.exports = (config, options) ->

  name = 'karma'
  description = 'Run unit tests in locally installed browsers.'

  gulp.task name, description, ['coffee'], (done) ->
    if options.watch
      gulp.watch [
        config.path.src + '/**/*.coffee'
        config.path.test.unit + '/**/*.coffee'
      ], [name]
    options =
      configFile: __dirname + '../config/karma.conf.coffee'
      singleRun: true
    cb = -> done()
    new karma.Server(options, cb).start()
  ,  {
    options:
      'watch': 'Watch for changes and re-run karma tests.'
  }
