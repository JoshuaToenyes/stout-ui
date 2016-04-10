###*
# @overview Defines the `HasHintViewTrait` which can be added to a view model to
# add a hint property. Works with the `HasHintViewTrait` for the view class.
#
# @module stout-ui/input/HasHintViewTrait
###
Foundation = require 'stout-core/base/Foundation'
Input      = require './Input'



###*
# The HasHintViewTrait can be used for input-type components which have a hint
# message.
#
# @exports stout-ui/input/HasHintViewTrait
# @mixin
###
module.exports = class HasHintViewTrait extends Foundation

  @cloneProperty Input, 'hint'

  ###*
  # Initiates this trait by syncing with the "hint" property on the view model.
  #
  # @method initTrait
  # @memberof stout-ui/input/HasHintViewTrait
  ###
  initTrait: ->
    @syncProperty @context, 'hint', inherit: false
