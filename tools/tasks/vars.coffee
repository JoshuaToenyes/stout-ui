###

vars Gulp Task

###

yaml       = require 'gulp-yaml'
gulp       = require('gulp-help')(require 'gulp')
jsonSass   = require 'gulp-json-sass'
# coffee     = require 'gulp-coffee'
# sourcemaps = require 'gulp-sourcemaps'


module.exports = (config, options) ->

  name = 'vars'
  src  = config.path.src + '/vars/**/*.yaml'

  gulp.task 'vars', 'Compile YAML variables to SASS.', ->
    if options.watch then gulp.watch src, [name]
    gulp.src src
    .pipe yaml()
    .pipe jsonSass
      sass: true
      escapeIllegalCharacters: false
    .pipe gulp.dest config.path.src + '/vars'
    .pipe gulp.dest config.path.target + '/vars'
