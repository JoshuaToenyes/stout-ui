###*
# @overview Defines the `HasValueView` trait which adds a "value" to a UI
# component view.
#
# @module stout-ui/traits/HasValueView
###
Foundation = require 'stout-core/base/Foundation'
HasValue   = require './HasValue'



###*
# The `HasValueView` represents the view part of a UI component which has a
# `value` property that can be edited or changed by the user. This trait should
# be mirrored in the view model by the `HasValue` trait. Other associated
# properties are also added to make working with a user-changeable component
# easier.
#
# @exports stout-ui/traits/HasValueView
# @mixin
###
module.exports = class HasValueView extends Foundation

  @cloneProperty HasValue, 'value dirty visited'


  ###*
  # Initialize this trait by syncing the associated properties with the
  # view-model and adding event listeners for setting the their values.
  #
  # @method initTrait
  # @memberof stout-ui/traits/HasValueView#
  # @private
  ###
  initTrait: ->
    @syncProperty @context, 'value dirty visited'
    @on 'blur', => @visited = true
    @once 'change:value', => @dirty = true
