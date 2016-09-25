###*
# @overview Defines the `enableable` trait, which adds enable/disable methods
# and properties to the using class.
#
# @module stout-ui/interactive/enableable
###


###*
# Adds enable and disable functionality and properties to the using class.
#
# @exports stout-ui/interactive/enableable
# @mixin
###
module.exports =

  ###*
  # Disabled this interactive component.
  #
  # @returns @
  #
  # @method disable
  # @memberof stout-ui/interactive/enableable#
  ###
  disable: ->
    @_disabled = true
    if @rendered then @prefixedClasses.add 'disabled'
    @


  ###*
  # Enables this interactive component.
  #
  # @returns @
  #
  # @method enable
  # @memberof stout-ui/interactive/enableable#
  ###
  enable: ->
    @_disabled = false
    if @rendered then @prefixedClasses.remove 'disabled'
    @


  ###*
  # Initiates the using class.
  #
  # @method init
  # @memberof stout-ui/interactive/enableable#
  ###
  init: ->
    Object.defineProperties @,
      disabled:
        set: (disabled) -> @enabled = not disabled
        get: -> not @enabled
      enabled:
        set: (enabled) -> if enabled then @enable() else @disable()
        get: -> @isEnabled()


  ###*
  # Returns `true` if this component is disabled.
  #
  # @see #isEnabled()
  #
  # @returns {boolean} `true` if disabled, otherwise false.
  #
  # @method isDisabled
  # @memberof stout-ui/interactive/enableable#
  ###
  isDisabled: -> not @isEnabled()


  ###*
  # Returns `true` or `false` indicating if this component is currently
  # enabled.
  #
  # @returns {boolean} `true` if enabled, otherwise false.
  #
  # @method isEnabled
  # @memberof stout-ui/interactive/enableable#
  ###
  isEnabled: -> not @_disabled
