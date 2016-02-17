###
dnt Gulp Task

Runs all unit tests in multiple versions of NodeJS and/or io.js using
Docker and DNT. To run this task, [Docker](https://www.docker.com/) and
[DNT](https://github.com/rvagg/dnt) must be installed and configured. See the
installation and setup instructions on the corresponding web sites. DNT
configuration is handled by the `.dntrc` file located at the directory root.
###

gulp  = require('gulp-help')(require 'gulp')
shell = require 'gulp-shell'



module.exports = ->

  gulp.task 'dnt', 'Runs unit tests in DNT.', shell.task ['dnt']
