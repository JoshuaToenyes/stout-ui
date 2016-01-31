# # `coffee:selenium`
#
# Compiles all CoffeeScript Selenium test files. The Selenium test files are
# separate from the source, and do not need to be bundled with the source since
# they're actually command files meant to be executed by the Selenium test
# server. In other words, they don't need any type of direct access to the
# source code because they only interact with the Selenium web driver.

coffee      = require 'gulp-coffee'
gulp        = require('gulp-help')(require 'gulp')



module.exports = (config) ->

  gulp.task 'coffee:selenium', false, ->
    gulp.src config.path.test.selenium + '/**/*.coffee'
    .pipe coffee()
    .pipe gulp.dest config.path.test.selenium
