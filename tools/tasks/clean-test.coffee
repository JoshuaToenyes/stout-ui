###

clean:test Gulp Task

Removes transpiled JavaScript test files from the test directories.

###

del  = require 'del'
gulp = require('gulp-help')(require 'gulp')



module.exports = (config) ->

  gulp.task 'clean:test', false, ->
    del [
      config.path.test + '/**/*.js'
      config.path.test + '/**/*.js.map'
    ]
