###*
# @overview Defines the pane fade transition.
# @module stout-ui/pane/fade
###
Promise = require 'stout-core/promise/Promise'


###*
# The pane fade transition fades the pane in-and-out. The JavaScript handles
# the translation positioning of the pane, while CSS handles the actual
# transition and fading effect.
#
# @exports stout-ui/pane/fade
###
module.exports =

  ###*
  # Sets-up the transition-out. This method is essentially a no-op.
  ###
  setupIn: -> Promise.fulfilled()


  ###*
  # Sets-up the transition-out. This method is essentially a no-op.
  ###
  setupOut: -> Promise.fulfilled()
