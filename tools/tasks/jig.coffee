###

jig Gulp Task

###

fs         = require 'fs'
gulp       = require('gulp-help')(require 'gulp')
jade       = require 'gulp-jade'
shell      = require 'gulp-shell'
browserify = require 'browserify'
sourcemaps = require 'gulp-sourcemaps'



module.exports = (config, options, flags) ->

  dummyName = 'jig:[name]'
  dummyDescription = 'Build a development jig.'

  gulp.task dummyName, dummyDescription, ->
    console.error 'You must specify a jig.'

  jigs = fs.readdirSync process.cwd() + '/' + config.path.jig

  for jig in jigs

    name = 'jig:' + jig

    ((jig, name)->

      gulp.task name, false, ['coffee:jig', 'jade:jig'], ->
        b = browserify
          entries: config.path.jig + '/' + jig + '/entry.js'
          debug: true

        b.bundle()
        .pipe source 'app.js'
        .pipe buffer()
        .pipe sourcemaps.init
          loadMaps: true
        .pipe sourcemaps.write './'
        .pipe gulp.dest config.path.jig


    )(jig, name)
