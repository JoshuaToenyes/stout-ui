# # `test:selenium:local`
#
# Runs Selenium tests on locally installed Selenium test server.

browserSync = require 'browser-sync'
gulp        = require('gulp-help')(require 'gulp')
selenium    = require './../helpers/selenium'
webdriver   = require 'gulp-webdriver'



module.exports = ->

  name = 'test:selenium:local'
  description = 'Run selenium tests on local Selenium server.'

  gulp.task name, description, ['serve', 'coffee:selenium'], (done) ->
    selenium.start ->
      gulp.src 'test/config/wdio-local.conf.js'
      .pipe webdriver()
      .once 'end', ->
        selenium.stop(done)
        browserSync.exit()
