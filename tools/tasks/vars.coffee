###

vars Gulp Task

###

yaml       = require 'gulp-yaml'
gulp       = require('gulp-help')(require 'gulp')
jsonSass   = require 'gulp-json-sass'
insert = require 'gulp-insert'
rename = require 'gulp-rename'
replace = require 'gulp-replace'
# coffee     = require 'gulp-coffee'
# sourcemaps = require 'gulp-sourcemaps'


module.exports = (config, options) ->

  name = 'vars'
  src  = config.path.src + '/vars/**/*.yaml'

  gulp.task 'vars', 'Compile YAML variables to SASS and JS.', ->
    if options.watch then gulp.watch src, [name]

    # Compile variables to SASS.
    gulp.src src
    .pipe yaml()
    .pipe jsonSass
      sass: true
      escapeIllegalCharacters: false
    .pipe gulp.dest config.path.target + '/vars'

    # Compile variables to JavaScript CommonJS.
    gulp.src src
    .pipe yaml()
    .pipe insert.prepend 'module.exports = '
    .pipe insert.append ';'
    .pipe rename
      extname: '.js'
    .pipe replace  /\s*!default\s*/g, ''
    .pipe replace  /\s+/g, ' '
    .pipe gulp.dest config.path.target + '/vars'
