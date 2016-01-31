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
    gulp.src config.path.src.coffee + '/**/*.coffee'
    .pipe sourcemaps.init()
    .pipe coffee()
    .pipe sourcemaps.write config.path.maps.js
    .pipe gulp.dest config.path.tmp.dist
    .on 'error', gutil.log