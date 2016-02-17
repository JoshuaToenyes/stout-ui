# # `build:test`
#
# Builds the project for testing.

gulp        = require('gulp-help')(require 'gulp')
runsequence = require 'run-sequence'




# @param {Object} options - Help command line options.

module.exports = (config, options, flags) ->

  gulp.task 'build:test', 'Builds the project for testing.', ->
    runsequence 'lint', 'test:unit', 'test:sauce'
  , {
    options: flags.bundle
  }