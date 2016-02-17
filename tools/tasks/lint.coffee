gulp       = require('gulp-help')(require 'gulp')



module.exports = (config) ->

  gulp.task 'lint', 'Lint source files.', ['lint:coffee', 'lint:sass']
