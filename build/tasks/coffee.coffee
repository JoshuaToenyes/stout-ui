# # `coffee`
#
# Compiles all CoffeeScript files into a single concatenated JavaScript file.


coffee     = require 'gulp-coffee'
gulp       = require('gulp-help')(require 'gulp')
gutil      = require 'gulp-util'
sourcemaps = require 'gulp-sourcemaps'




# @param {Object} config - Build configuration object.

module.exports = (config) ->

  gulp.task 'coffee', 'Transpiles CoffeeScript to JavaScript.', ->
    gulp.src config.path.src + '/**/*.coffee'
    .pipe sourcemaps.init()
    .pipe coffee()
    .pipe sourcemaps.write './',
      includeContent: true
      sourceRoot: '../src/coffee'
    .pipe gulp.dest config.path.target
    .on 'error', gutil.log
