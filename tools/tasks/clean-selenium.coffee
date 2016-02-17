# # `clean:selenium`
#
# Removes compiled selenium test files.

del  = require 'del'
gulp = require('gulp-help')(require 'gulp')



# @param {Object} config - Build configuration object.

module.exports = (config) ->

  gulp.task 'clean:selenium', false, ->
    del config.path.test.selenium + '/**/*.js'
