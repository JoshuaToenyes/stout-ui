# # `test:unit:sauce`
#
# Runs unit tests in locally installed browsers.

gulp  = require('gulp-help')(require 'gulp')
karma = require 'karma'



# @param {boolean} watch - `true` to watch for changes and re-run.

module.exports = (config, options) ->

  name = 'test:unit:sauce'
  description = 'Run unit tests in locally installed browsers.'

  gulp.task name, description, ['bundle:test'], (done) ->

    jobNum = process.env.TRAVIS_JOB_NUMBER

    # If in the CI environment, and this isn't the first job (i.e. we're
    # testing multiple versions of NodeJS on Travis-CI), then don't run the
    # Sauce Labs unit tests.
    if jobNum? and jobNum[jobNum.length - 1] isnt '1'
      return done()

    if options.watch
      gulp.watch [
        config.path.src.coffee + '/**/*.coffee'
        config.path.test.unit + '/**/*.coffee'
      ], [name]
    opts =
      configFile: __dirname + '/../../test/config/karma-sauce.conf.coffee'
      singleRun: true

    # Exit with error code if in the CI environment. We want to fail the build
    # if cross-browser testing doesn't pass.
    cb = (exitCode) ->
      if process.env.CI and exitCode isnt 0
        process.exit exitCode
      else
        done()

    new karma.Server(opts, cb).start()
