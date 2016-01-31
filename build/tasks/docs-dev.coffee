# # `docs:dev`
#
# Starts documentation tasks for serving documentation and watching source files
# for changes. This task is ideal for developing and watching documentation
# simultaneously.

gulp  = require('gulp-help')(require 'gulp')
shell = require 'gulp-shell'



module.exports = ->

  gulp.task 'docs:dev', 'Serve and watch documentation.', shell.task [
    '(gulp docs:serve &) && (gulp docs:watch)'
  ]
