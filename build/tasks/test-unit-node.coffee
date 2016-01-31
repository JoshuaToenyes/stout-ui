# # `test:unit:node`
#
# Runs unit tests in the locally installed and running NodeJS (or io.js)
# environment.

gulp  = require('gulp-help')(require 'gulp')
mocha = require 'gulp-mocha'



module.exports = (config, options) ->

  name = 'test:unit:node'
  description = 'Run unit tests in running NodeJS or io.js environment.'
  src = config.path.target + '/**/*.js'

  gulp.task name, description, ['bundle:test'], ->
    if options.watch
      gulp.watch [
        config.path.src.coffee + '/**/*.coffee'
        config.path.test.unit + '/**/*.coffee'
      ], [name]
    gulp.src(src).pipe mocha()
