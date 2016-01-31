# # `test:selenium:sauce`
#
# Runs Selenium tests on [Sauce Labs](https://saucelabs.com/) automated
# cross-browser testing service.

gulp      = require('gulp-help')(require 'gulp')
sauce     = require './../helpers/sauce-connect'
webdriver = require 'gulp-webdriver'



module.exports = ->

  name = 'test:selenium:sauce'
  description = 'Run selenium tests on Sauce Labs.'

  gulp.task name, description, ['serve', 'coffee:selenium'], (done) ->
    sauce.connect ->
      gulp.src 'test/config/wdio-saucelabs.conf.js'
      .pipe webdriver()
      .once 'end', ->
        sauce.disconnect()
        done()
