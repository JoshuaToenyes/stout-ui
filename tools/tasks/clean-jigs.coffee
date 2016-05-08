###

clean:jigs Gulp Task

Removes transpiled JavaScript test files from the test directories.

###

del  = require 'del'
gulp = require('gulp-help')(require 'gulp')



module.exports = (config) ->

  gulp.task 'clean:jigs', false, ->
    del [
      config.path.jig + '/**/*.html'
      '!' + config.path.jig + '/_dummy/*.html'
      config.path.jig + '/**/*.js'
      config.path.jig + '/**/*.js.map'
      config.path.jig + '/**/*.css'
      config.path.jig + '/**/*.css.map'
    ]
