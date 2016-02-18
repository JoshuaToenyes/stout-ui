###

coffee:src Gulp Task

Transpiles all source CoffeeScript files.

###

coffee     = require 'gulp-coffee'
gulp       = require('gulp-help')(require 'gulp')
gutil      = require 'gulp-util'
sourcemaps = require 'gulp-sourcemaps'
sass       = require 'gulp-sass'



module.exports = (config, options) ->

  src = config.path.jig + '/**/*.sass'
  name = 'sass:jig'
  opts =
    includePaths: ['src', 'lib']

  gulp.task name, false, ->
    if options.watch then gulp.watch src, [name]
    gulp.src src
    .pipe sourcemaps.init()
    .pipe sass(opts).on('error', sass.logError)
    .pipe sourcemaps.write '.'
    .pipe gulp.dest config.path.jig
    .on 'error', gutil.log
