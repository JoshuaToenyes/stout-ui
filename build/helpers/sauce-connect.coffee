###
# # Sauce Labs Connection Helper
#
# Handles connecting and disconnecting from the Sauce Labs testing service.
###

gutil = require 'gulp-util'
sauce = require 'sauce-connect-launcher'



# Reference to living sauce-connect connection.
connection = null



module.exports =

  ###
  # Connects to Sauce Labs.
  #
  # @function module.exports.connect(done)
  #
  # @param {function} [done] - Function to call when connection attempt is
  # complete. If an error occurred, it is passed as the function's only
  # parameter.
  ###

  connect: (done) ->

    credentials =
      username: process.env.SAUCE_USERNAME
      accessKey: process.env.SAUCE_ACCESS_KEY
      verbose: true
      verboseDebugging: true
      logger: gutil.log

    sauce credentials, (err, child) ->
      if err
        gutil.log err
      else
        connection = child
      done?(err)


  ###
  # Disconnects from Sauce Labs.
  #
  # @function module.exports.disconnect()
  ###

  disconnect: ->
    connection?.close()