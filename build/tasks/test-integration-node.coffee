# # `test:integration:node`
#
# Runs integration tests in the locally installed and running NodeJS (or io.js)
# environment.

gulp  = require('gulp-help')(require 'gulp')
mocha = require 'gulp-spawn-mocha'



module.exports = (config, options) ->

  name = 'test:integration:node'
  description = 'Run integration tests in running NodeJS or io.js environment.'
  src = config.path.target + '/**/*.js'

  gulp.task name, description, ['bundle:test:integration'], ->
    if options.watch
      gulp.watch [
        config.path.src.coffee + '/**/*.coffee'
        config.path.test.integration + '/**/*.coffee'
      ], [name]
    gulp.src(src).pipe mocha({
      debugBrk: options.debug
    })
