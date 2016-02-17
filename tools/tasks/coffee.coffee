###

coffee Gulp Task

Transpiles all project CoffeeScript: source, unit tests, and e2e tests.

###

coffee     = require 'gulp-coffee'
gulp       = require('gulp-help')(require 'gulp')
gutil      = require 'gulp-util'
sourcemaps = require 'gulp-sourcemaps'



module.exports = (config) ->

  gulp.task 'coffee', 'Transpiles all CoffeeScript to JavaScript.', [
    'coffee:src'
    'coffee:test'
  ], null, {
    options:
      'watch': 'Watch for changes and re transpile CoffeeScript.'
  }
