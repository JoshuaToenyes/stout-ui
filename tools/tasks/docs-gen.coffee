# # `docs:gen`
#
# Generates project documentation (what you're reading) using
# [Groc](http://nevir.github.io/groc/).

gulp  = require('gulp-help')(require 'gulp')
shell = require 'gulp-shell'



module.exports = ->

  gulp.task 'docs:gen', 'Generates project documentation.', shell.task [
    './node_modules/groc/bin/groc'
  ]
