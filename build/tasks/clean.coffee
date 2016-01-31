# # `clean`
#
# Cleans all all build, documentation, and temporary files. Running this task
# essentially "resets" the build system so no existing or left-over files can
# cause any problems.


del         = require 'del'
gulp        = require('gulp-help')(require 'gulp')




# @param {Object} config - Build configuration object.

module.exports = (config) ->

  gulp.task 'clean', 'Cleans project paths.', ['clean:test'], ->
    del [
      config.path.target
      config.path.tmp.root
      config.path.doc
    ]