# # `build`
#
# Builds the entire project for distribution.


gulp = require('gulp-help')(require 'gulp')



# @param {Object} options - Help command line options.

module.exports = (config, options, flags) ->

  gulp.task 'build', 'Builds the project.', [
    'lint', 'test:unit:node', 'test:unit:sauce'], ->
    null
  , {
    options: flags.bundle
  }