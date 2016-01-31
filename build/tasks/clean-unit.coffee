# # `clean:unit`
#
# Removes compiled unit test files.


del  = require 'del'
gulp = require('gulp-help')(require 'gulp')




# @param {Object} config - Build configuration object.

module.exports = (config) ->

  gulp.task 'clean:unit', false, ->
    del config.path.test.unit + '/**/*.js'
