###
# # Local Selenium Server Helper
#
# Installs a local Standalone Selenium installation.
#
# *Note: The `logger` property is set to an empty function which suppresses
# output. If you're having problems installing selenium, replace it with
# `gutil.log`.*
###

selenium = require 'selenium-standalone'
instance = null



module.exports =

  ###
  # Installs (if necessary) and starts local Selenium server.
  #
  # @function module.exports.start(done)
  #
  # @param {function} [done] - Function to call when Selenium server is started.
  # If an error occurrs, the error object will be passed as the only parameter
  # to the callback function.
  ###

  start: (done) ->

    onInstallComplete = ->
      selenium.start (err, child) ->
        instance = child
        done?(err)

    selenium.install
      logger: ->
    , onInstallComplete


  ###
  # Stops the local Selenium server.
  #
  # @function module.exports.stop(done)
  #
  # @param {function} [done] - Function to call when Selenium server is stopped.
  ###
  stop: (done) ->
    instance.kill()
    done?()
