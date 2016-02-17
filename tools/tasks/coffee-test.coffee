###

coffee:test Gulp Task

Transpiles all CoffeeScript test files.

###

coffee     = require 'gulp-coffee'
gulp       = require('gulp-help')(require 'gulp')
sourcemaps = require 'gulp-sourcemaps'
gutil      = require 'gulp-util'



module.exports = (config, options) ->

  src = "#{config.path.test}/**/*.coffee"

  gulp.task 'coffee:test', false, ->
    if options.watch
      gulp.watch src, ['coffee:test']
    gulp.src src
    .pipe sourcemaps.init()
    .pipe coffee()
    .pipe sourcemaps.write '.',
      includeContent: true
      sourceRoot: '../' + config.path.test
    .pipe gulp.dest "./#{config.path.test}"
    .on 'error', gutil.log
