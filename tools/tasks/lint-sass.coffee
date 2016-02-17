# # `lint:sass`
#
# Lints all SASS source files.


gulp        = require('gulp-help')(require 'gulp')
gulpif      = require 'gulp-if'
sassLint    = require 'gulp-sass-lint'



# @param {Object} config - Build configuration object.
# @param {boolean} failOnError - `true` to fail and trigger non-zero exit code
# on SASS lint error.

module.exports = (config, options, flags) ->

  name = 'lint:sass'
  src  = config.path.src + '/**/*.sass'

  gulp.task name, 'Lints SASS files.', ->

    if options.watch then gulp.watch src, [name]

    gulp.src src
    .pipe sassLint()
    .pipe sassLint.format()
    .pipe gulpif(options.failOnError, sassLint.failOnError())
