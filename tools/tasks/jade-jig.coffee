###

jade:jig Gulp Task

Compiles Jade jig template to HTML.

###

jade       = require 'gulp-jade'
gulp       = require('gulp-help')(require 'gulp')



module.exports = (config, options) ->

  src = config.path.jig + '/**/*.jade'
  name = 'jade:jig'

  gulp.task name, false, ->
    if options.watch then gulp.watch src, [name]
    gulp.src src
    .pipe jade()
    .pipe gulp.dest config.path.jig
