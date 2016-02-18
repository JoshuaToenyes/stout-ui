###

coffee:src Gulp Task

Transpiles all source CoffeeScript files.

###

coffee     = require 'gulp-coffee'
gulp       = require('gulp-help')(require 'gulp')
gutil      = require 'gulp-util'
sourcemaps = require 'gulp-sourcemaps'



module.exports = (config, options) ->

  src = config.path.src + '/**/*.coffee'

  gulp.task 'coffee:src', false, ->
    if options.watch
      gulp.watch src, ['coffee:src']
    gulp.src src
    .pipe sourcemaps.init()
    .pipe coffee()
    .pipe sourcemaps.write()
    .pipe gulp.dest config.path.target
    .on 'error', gutil.log
