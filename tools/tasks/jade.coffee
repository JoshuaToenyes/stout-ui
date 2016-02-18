###

jade Gulp Task

Compiles Jade templates to JavaScript.

###

jade   = require 'gulp-jade'
gulp   = require('gulp-help')(require 'gulp')
insert = require 'gulp-insert'


module.exports = (config, options) ->

  src = config.path.src + '/**/*.jade'
  name = 'jade'

  gulp.task name, false, ->
    if options.watch then gulp.watch src, [name]
    gulp.src src
    .pipe jade
      client: true
    .pipe insert.prepend 'jade = require(\'jade/runtime\');'
    .pipe insert.append 'module.exports = template;'
    .pipe gulp.dest config.path.target
