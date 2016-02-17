# # `test:unit:sauce`
#
# Runs unit tests in locally installed browsers.

gulp  = require('gulp-help')(require 'gulp')
karma = require 'karma'



module.exports = (config) ->

  name = 'sauce'
  description = 'Run unit tests on SauceLabs.'

  gulp.task name, description, ['coffee'], (done) ->

    jobNum = process.env.TRAVIS_JOB_NUMBER

    # If in the CI environment, and this isn't the first job (i.e. we're
    # testing multiple versions of NodeJS on Travis-CI), then don't run the
    # Sauce Labs unit tests.
    if jobNum? and jobNum[jobNum.length - 1] isnt '1'
      return done()

    opts =
      configFile: __dirname + '/../config/karma-sauce.conf.coffee'
      singleRun: true

    # Exit with error code if in the CI environment. We want to fail the build
    # if cross-browser testing doesn't pass.
    cb = (exitCode) ->
      if process.env.CI and exitCode isnt 0
        process.exit exitCode
      else
        done()

    new karma.Server(opts, cb).start()
