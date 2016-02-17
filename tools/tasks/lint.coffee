# # `lint`
#
# Lints all project files.

gulp        = require('gulp-help')(require 'gulp')
runsequence = require 'run-sequence'



module.exports = (config, options, flags) ->

  gulp.task 'lint', 'Lint project source files.', ->
    runsequence 'lint:sass', 'lint:coffee'
  , {
    options: flags.lint
  }
