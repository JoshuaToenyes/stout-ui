###

clean Gulp Task

Removes all transpiled JavaScript files and sourcemaps, and generated coverage
or documentation files.

###

del         = require 'del'
gulp        = require('gulp-help')(require 'gulp')



module.exports = (config) ->

  gulp.task 'clean', 'Cleans project paths.', ['clean:test', 'clean:target', 'clean:jigs'], ->
    del [
      config.path.coverage
      config.path.doc
      config.path.src + '/vars/**/*.sass'
    ]
