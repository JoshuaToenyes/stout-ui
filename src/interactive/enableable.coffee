###*
# @overview Defines the `enableable` trait, which adds enable/disable methods
# and properties to the using class.
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
  # Disabled this interactive component. By default it add the `disabled`
  # attribute to the element returned by `_getDisableTarget()`. This behavior
  # may be overriden by extending classes for more complex behavior. If this
  # component is not yet rendered, or is already disabled calling this method
  # has no effect.
  #
  # @returns @
  #
  # @method disable
  # @memberof stout-ui/interactive/enableable#
  ###
  disable: ->
    @_disabled = true
    if @rendered then @_getDisableTarget().setAttribute 'disabled', ''
    @


  ###*
  # Enables this interactive component. By default it removes the `disabled`
  # attribute from the element returned by `_getDisableTarget()`. This behavior
  # may be overriden by extending classes for more complex behavior. If this
  # component is not yet rendered, or is not disabled calling this method has
  # no effect.
  #
  # @returns @
  #
  # @method enable
  # @memberof stout-ui/interactive/enableable#
  ###
  enable: ->
    @_disabled = false
    if @rendered then @_getDisableTarget().removeAttribute 'disabled'
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
  # Returns the inverse of `isEnabled()`.
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
  # disabled. By default it just indicates if the element returned by
  # `_getDisableTarget()` has the attribute `disabled`. This behavior may be
  # overriden by extending classes for more complex functionality. This method
  # will return `false` if the component is not rendered.
  #
  # @returns {boolean} `true` if enabled, otherwise false.
  #
  # @method isEnabled
  # @memberof stout-ui/interactive/enableable#
  ###
  isEnabled: -> not @_disabled
