###*
# Copies assets in to location.
###
gulp       = require('gulp-help')(require 'gulp')



module.exports = (config, options) ->

  gulp.task 'assets', 'Copies assets in to location for distribution.', ->
    gulp.src config.path.src + '/**/*.sass'
    .pipe gulp.dest config.path.target
