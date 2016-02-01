###
# # `bundle:*` Task Factory
#
# Builds Gulp bundle tasks.
###

gulp    = require('gulp-help')(require 'gulp')
webpack = require 'webpack-stream'
gutil   = require 'gulp-util'
webpackHelper = require './../helpers/webpack-config'



###
# @function module.exports
#
# @param {Object} config - Build configuration object.
#
# @param {Object} task - Object describing task to create.
###
module.exports = (config, task) ->

  gulp.task task.name, task.description, ['clean:target'], ->
    [webpackConfig, entry] = webpackHelper(
      config, task.uglify, task.env, task.watch)

    entry = task.entry or entry

    gulp.src entry
    .pipe webpack webpackConfig
    .pipe gulp.dest task.target or config.path.target.dist
    .on 'error', gutil.log
  , {
    options: task.flags
  }
