# # `docs:watch`
#
# Watches source files and re-generates the documentation when something
# a file changes. Only documentation for updated files is generated, so it's
# not a long-running task.

gulp = require('gulp-help')(require 'gulp')



module.exports = (config) ->

  gulp.task 'docs:watch', 'Watch source files and regenerate docs.', ->
    gulp.watch [
      config.path.build.root + '/**/*'
      config.path.src.root + '/**/*'
      config.path.test.root + '/**/*'
    ], ['docs:gen']
