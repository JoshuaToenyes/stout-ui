###*
# @overview Defines the EnableableViewTrait which can be added to view classes
# to easily enable/disable a component.
#
# @module stout-ui/interactive/EnableableViewTrait
###

Foundation = require 'stout-core/base/Foundation'



###*
# EnableableViewTrait is a trait which may be added to a component class to
# allow for enabling/disabling the component by adding/removing the prefixed
# "disabled" class. The trait syncs the `enabled` and `disabled` properties
# with the view's context (view model).
#
# @exports stout-ui/interactive/EnableableViewTrait
# @mixin
###
module.exports = class EnableableViewTrait extends Foundation

  ###*
  # The `disabled` property sets or gets if this view is disabled.
  #
  # @member disabled
  # @memberof stout-ui/interactive/EnableableViewTrait#
  ###
  @property 'disabled',
    get: -> not @enabled
    set: (disabled) -> @enabled = not disabled


  ###*
  # The `enabled` property sets or gets if this view is enabled.
  #
  # @member disabled
  # @memberof stout-ui/interactive/EnableableViewTrait#
  ###
  @property 'enabled',
    get: -> not @prefixedClasses.contains 'disabled'
    set: (s) ->
      if s and @disabled
        @prefixedClasses.remove 'disabled'
        if @eventRegistered('enable') then @fire 'enable'
      else if not s and @enabled
        @prefixedClasses.add 'disabled'
        if @eventRegistered('disable') then @fire 'disable'
      s


  ###*
  # Initiates this trait by syncing the `enabled` and `disabled` properties
  # with this view's context.
  #
  # @method initTrait
  # @memberof stout-ui/interactive/EnableableViewTrait#
  # @private
  ###
  initTrait: ->
    @syncProperty @context, 'enabled'
    @registerEvents ['enable', 'disable']
