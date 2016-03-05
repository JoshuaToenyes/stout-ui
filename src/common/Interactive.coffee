dom        = require 'stout-core/utilities/dom'
Component  = require './Component'

STATE =
  DEFAULT: 1  # Normal static state.
  HOVER:   2  # Mouse is over the button.
  ACTIVE:  3  # Mouse is down over button.
  FOCUS:   4  # Button is focused.


##
# Interactive component which can be enabled/disabled and triggers mouse events
# such as `hover`, `leave`, and events `active` and `focus`.
#
# @class Interactive

module.exports = class Interactive extends Component

  @property 'click',
    serializable: false

    set: (fn) ->
      if not fn then return
      setTimeout =>
        @on 'click', fn
      , 0

  ##
  # Interactive constructor creates a new Interactive component instance and
  # passes all arguments to the parent class.
  #
  # @see Component#constructor
  #
  # @constructor

  constructor: (template, model, opts, init, events = []) ->
    super template, model, opts, init, [
      'hover'
      'leave'
      'active'
      'focus'].concat events
    @_hoverTimer = null
    @_disabled = false
    @_state = STATE.DEFAULT


  ##
  # Renders this component and adds approriate event listeners for hover events.
  #
  # @returns {HTMLElement} The rendered root HTML DOM node.
  #
  # @method render
  # @public

  render: ->
    super()
    b = @_getHoverTarget()
    b.addEventListener 'click', @_onClick
    b.addEventListener 'mousedown', @_onMouseDown
    b.addEventListener 'focus', @_onFocus
    b.addEventListener 'mouseenter', @_onMouseEnter
    b.addEventListener 'mouseleave', @_onMouseLeave
    if @_disabled
      @_getDisableTarget()?.setAttribute 'disabled', ''
    else
      @_getDisableTarget()?.removeAttribute 'disabled'
    @root


  ##
  # Removes all attached DOM event listeners and calls the parent `destroy()`
  # method.
  #
  # @method destroy
  # @public

  destroy: ->
    b = @_getHoverTarget()
    b.removeEventListener 'click', @_onClick
    b.removeEventListener 'mousedown', @_onMouseDown
    b.removeEventListener 'focus', @_onFocus
    b.removeEventListener 'mouseenter', @_onMouseEnter
    b.removeEventListener 'mouseleave', @_onMouseLeave
    super()


  ##
  # Called when a native click event is detected on the hover target element.
  # If this Interactive is enabled, a corresponding `click` event is fired.
  #
  # @method _onClick
  # @private

  _onClick: (e) =>
    if @enabled then @fire 'click', e


  ##
  # Called when a native mouse down event is detected on the hover target
  # element. If this Interactive is enabled, a corresponding `active` event
  # is fired.
  #
  # @method _onMouseDown
  # @private

  _onMouseDown: (e) =>
    if @enabled then @fire 'active', e


  ##
  # Called when a native focus event is detected on the hover target element.
  # If this Interactive is enabled, a corresponding `focus` event is fired.
  #
  # @method _onFocus
  # @private

  _onFocus: (e) =>
    if @enabled then @fire 'focus', e


  ##
  # Private method called when a native mouse enter event is detected. This
  # enter event is used to trigger a corresponding `hover` event.
  #
  # @method _onMouseEnter
  # @private

  _onMouseEnter: (e) =>
    clearTimeout @_hoverTimer
    if @_state is STATE.HOVER then return
    @_state = STATE.HOVER
    @fire 'hover', e


  ##
  # Private method called when a native mouse leave event is detected. This
  # enter event is used to trigger a corresponding `leave` event, signalling
  # the end of a hover.
  #
  # @method _onMouseLeave
  # @private

  _onMouseLeave: (e) =>
    self = @
    @_hoverTimer = setTimeout ->
      self._state = STATE.DEFAULT
      self.fire 'leave', e
    , 10


  ##
  # Returns the target element that should be "disabled". By default this
  # method returns the first `input` element of the component but this behavior
  # may be overridden by extending classes for more complex behavior.
  #
  # @method _getDisableTarget
  # @protected

  _getDisableTarget: -> @select 'input'


  ##
  # Returns the target element that should trigger hover and mouse events. By
  # default it returns the component's root element.
  #
  # @method _getHoverTarget
  # @protected

  _getHoverTarget: -> @root
