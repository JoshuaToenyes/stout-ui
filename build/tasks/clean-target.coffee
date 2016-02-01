# # `clean:target`
#
# Removes compiled files from the target directory.

del  = require 'del'
gulp = require('gulp-help')(require 'gulp')



# @param {Object} config - Build configuration object.

module.exports = (config) ->

  gulp.task 'clean:target', 'Clean compiled files from target directory.', ->
    del [
      config.path.target.dist
      config.path.target.example
    ]
