# # `coffee:unit`
#
# Compiles all CoffeeScript unit test files.

coffee      = require 'gulp-coffee'
gulp        = require('gulp-help')(require 'gulp')



module.exports = (config) ->

  gulp.task 'coffee:unit', false, ['coffee'], ->
    gulp.src config.path.test.unit + '/**/*.coffee'
    .pipe coffee()
    .pipe gulp.dest config.path.tmp.unit
