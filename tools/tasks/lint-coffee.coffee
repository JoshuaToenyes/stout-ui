# # `lint:coffee`
#
# Lints all CoffeeScript source files. If the `--fail-on-first` flag is passed
# then this task will exit with a non-zero exit code if any lint "errors"
# are found.


coffeelint = require 'gulp-coffeelint'
gulp       = require('gulp-help')(require 'gulp')
gulpif     = require 'gulp-if'



# @param {Object} config - Build configuration object.
# @param {boolean} failOnError - `true` to fail and trigger non-zero exit code
# on CoffeeScript lint error.

module.exports = (config, options) ->

  name = 'lint:coffee'

  gulp.task name, 'Lints source files.', ->

    src = [
      config.path.src + '/**/*.coffee'
      config.path.test + '/**/*.coffee'
    ]

    if options.watch then gulp.watch src, [name]

    gulp.src src
    .pipe coffeelint
      optFile: './.coffeelint.json'
    .pipe coffeelint.reporter 'coffeelint-stylish'
    .pipe gulpif(options.failOnError, coffeelint.reporter('fail'))

  , {
    options:
      'fail-on-error': 'Exit with non-zero code when an error is encountered.'
      'watch': 'Watch for changes and re-lint files.'
  }
