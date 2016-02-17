###

clean Gulp Task

Removes all transpiled JavaScript files and sourcemaps, and generated coverage
or documentation files.

###

gulp  = require('gulp-help')(require 'gulp')
shell = require 'gulp-shell'


module.exports = (config) ->

  description = 'Check for unused project dependencies'

  gulp.task 'depcheck', description, ['coffee'], shell.task [
    'depcheck --ignores=karma*,ink-docstrap,browserify'
  ], {
    ignoreErrors: true
  }
