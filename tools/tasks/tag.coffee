# # `tag`
#
# Simple task to tag the git repo at it's current version as-specified by
# the package.json file.

git  = require 'gulp-git'
gulp = require('gulp-help')(require 'gulp')



module.exports = ->

  gulp.task 'tag', 'Tags the project at it\'s current version.', ->
    gulp.src ['./package.json']
    .pipe tag()
