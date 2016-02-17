# # `test:unit:node`
#
# Runs unit tests in the locally installed and running NodeJS (or io.js)
# environment.

gulp     = require('gulp-help')(require 'gulp')
shell    = require 'gulp-shell'
mocha    = require 'gulp-mocha'
istanbul = require 'gulp-istanbul'



module.exports = (config, options) ->

  name = 'coverage'
  description = 'Generate unit test coverage report'
  dir = config.path.coverage

  gulp.task name, description, ['clean:test'], shell.task [
    "rm -rf #{dir}"
    "mkdir #{dir}"
    "cp -r #{config.path.src}/* #{dir}"
    "cp -r #{config.path.test} #{dir}"
    "cd #{dir} && mocha --recursive --compilers coffee:coffee-script/register --require ../#{config.path.tools}/helpers/coffee-coverage-loader.js test/unit"
    "cd #{dir} && istanbul report"
    "cd #{dir} && open coverage/lcov-report/index.html"
  ]
