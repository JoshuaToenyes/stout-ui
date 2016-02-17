# # `build`
#
# Builds the entire project for distribution.


gulp = require('gulp-help')(require 'gulp')
run  = require 'run-sequence'


# @param {Object} options - Help command line options.

module.exports = (config, options, flags) ->

  gulp.task 'build', 'Builds, lints, and tests the project.', ->
      run ['lint', 'coffee'], 'sauce'
  , {
    options:
      'fail-on-error': 'Exit with non-zero code when an error is encountered.'
  }
