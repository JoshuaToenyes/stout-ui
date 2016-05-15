###*
# Copies assets in to location.
###
gulp       = require('gulp-help')(require 'gulp')



module.exports = (config, options) ->

  src = [
    config.path.src + '/**/*.sass'
    config.path.src + '/**/*.scss'
  ]

  gulp.task 'assets', 'Copies assets in to location for distribution.', ->
    gulp.src src
    .pipe gulp.dest config.path.target
