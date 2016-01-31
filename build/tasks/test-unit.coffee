# # `test:unit`
#
# Runs unit tests on locally running NodeJS or io.js version and on locally
# installed browsers.

gulp  = require('gulp-help')(require 'gulp')



module.exports = ->

  description = 'Run unit tests on local browsers and running NodeJS/io.js.'

  gulp.task 'test:unit', description, ['test:unit:node', 'test:unit:browsers']
