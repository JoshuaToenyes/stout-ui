###*
# @overview Defines the InteractiveView class which can be extended to create
# interactive UI components which automatically handle mouse, hover, focus,
# blur and other common interactive states and behaviors.
#
# @module stout-ui/interactive/InteractiveView
###

ComponentView = require '../component/ComponentView'
nextTick      = require 'stout-client/util/nextTick'


###*
# State definitions for hover state.
#
# @type {Object.<string, number>}
# @const
###
STATE =
  DEFAULT: 1  # Normal static state.
  HOVER:   2  # Mouse is over the button.
  ACTIVE:  3  # Mouse is down over button.
  FOCUS:   4  # Button is focused.


EVENTS = ['blur', 'focus', 'active', 'hover', 'click', 'tap', 'leave']


###*
# The InteractiveView class defines the view of a UI component with support for
# common UI component states and behaviors such as blur, focus, mouseenter,
# mouseleave, etc.
#
# @exports stout-ui/interactive/InteractiveView
# @extends stout-ui/component/ComponentView
# @constructor
###
module.exports = class InteractiveView extends ComponentView

  constructor: (init, events = []) ->
    super init, events.concat EVENTS
    @_state = STATE.DEFAULT
    @_interactiveEventListeners = []
    @_focusEventListeners = []


  # Add event properties for each.
  EVENTS.forEach (eventName) =>
    @property eventName,
      serializable: false
      set: (handler) ->
        switch typeof handler
          when 'string'
            nextTick => @on eventName, @context[handler]
          when 'function'
            nextTick => @on eventName, handler


  ###*
  # Optionally, key codes may be added to this array. If specified, when the
  # component is in-focus, pressing these keys will cause it to "activate" on
  # key-down, and "deactivate" on key up. This is the behavior desired by
  # buttons, for example.
  #
  # @member {Array.<number>} activateKeys
  # @memberof stout-ui/interactive/InteractiveView#
  ###
  @property 'activateKeys',
    default: []


  ###*
  # Set of focus-specific event listeners.
  #
  # @member {timer} _focusEventListeners
  # @memberof stout-ui/interactive/InteractiveView#
  ###


  ###*
  # Set of interactive event listeners in the form of [target, event, listener].
  # This array is used to unbind later when this `InteractiveView` is destroyed.
  #
  # @member {timer} _interactiveEventListeners
  # @memberof stout-ui/interactive/InteractiveView#
  ###


  ###*
  # Adds interactive event listeners.
  #
  # @method _addInteractiveEventListeners
  # @memberof stout-ui/interactive/InteractiveView#
  ###
  _addInteractiveEventListeners: ->
    [at, ht, ft] = [@getActiveTarget(), @getHoverTarget(), @getFocusTarget()]
    fn = (target, event, handler) =>
      listeners = @addEventListenerTo arguments...
      @_interactiveEventListeners.push [target, event, listeners]
    fn at, 'mousedown', @_mousedown
    fn at, 'mouseup', @_mouseup
    fn ht, 'mouseenter', @_mouseenter
    fn ht, 'mouseleave', @_mouseleave
    fn ft, 'focus', @_focus
    fn ft, 'blur', @_blur
    fn ft, 'tap', @_tap


  ###*
  # Adds focus-related event listeners.
  #
  # @method _addFocusEventListeners
  # @memberof stout-ui/interactive/InteractiveView#
  ###
  _addFocusEventListeners: ->
    ft = @getFocusTarget()

    downListeners = @addEventListenerTo ft, 'keydown', (e) =>
      keycode = e.which
      if keycode in @activateKeys
        e.preventDefault()
        if @fireInteractiveEvent('active', e) and
        not @prefixedClasses.contains 'active'
          @prefixedClasses.add 'active'
          @fire 'active:keydown'
          @fire 'tap'
          @fire 'click'
    @_focusEventListeners.push [ft, 'keydown', downListeners]

    upListeners = @addEventListenerTo ft, 'keyup', (e) =>
      keycode = e.which
      if keycode in @activateKeys
        if @fireInteractiveEvent('active', e)
          @prefixedClasses.remove 'active'
          @fire('active:keyup')
    @_focusEventListeners.push [ft, 'keyup', downListeners]


  ###*
  # Removes interactive event listeners added by this class from DOM nodes.
  #
  # @method _removeInteractiveEventListeners
  # @memberof stout-ui/interactive/InteractiveView#
  ###
  _removeInteractiveEventListeners: ->
    for entry in @_interactiveEventListeners
      @removeEventListenerFrom entry...
    @_interactiveEventListeners = []


  ###*
  # Removes focus-related event listeners.
  #
  # @method _removeFocusEventListeners
  # @memberof stout-ui/interactive/InteractiveView#
  ###
  _removeFocusEventListeners: ->
    for entry in @_focusEventListeners
      @removeEventListenerFrom entry...
    @_focusEventListeners = []


  ###*
  # Called when a native blur event is detected on the hover target element.
  #
  # @method _blur
  # @memberof stout-ui/interactive/InteractiveView#
  ###
  _blur: (e) =>
    if @fireInteractiveEvent('blur', e)
      @prefixedClasses.remove 'active'
      @prefixedClasses.remove 'focus'
      @_removeFocusEventListeners()
      @fire 'blur', e


  ###*
  # Called when a native focus event is detected on the hover target element.
  # If this Interactive is enabled, a corresponding `focus` event is fired.
  #
  # @method _focus
  # @memberof stout-ui/interactive/InteractiveView#
  ###
  _focus: (e) =>
    if @fireInteractiveEvent('focus', e)
      @prefixedClasses.add 'focus'
      @_addFocusEventListeners()
      @fire 'focus', e


  ###*
  # Called when a native mouse down event is detected on the hover target
  # element. If this Interactive is enabled, a corresponding `active` event
  # is fired.
  #
  # @method _mousedown
  # @memberof stout-ui/interactive/InteractiveView#
  ###
  _mousedown: (e) =>
    if @fireInteractiveEvent('active', e)
      @prefixedClasses.add 'active'

      fn = (e) =>
        @prefixedClasses.remove 'active'
        document.removeEventListener 'mouseup', fn
      document.addEventListener 'mouseup', fn

      @fire 'active', e


  ###*
  # Private method called when a native mouse enter event is detected. This
  # enter event is used to trigger a corresponding `hover` event.
  #
  # @method _mouseenter
  # @memberof stout-ui/interactive/InteractiveView#
  ###
  _mouseenter: (e) =>
    clearTimeout @_hoverTimer
    if @_state is STATE.HOVER then return
    @_state = STATE.HOVER
    @_hoverTimer = null
    @prefixedClasses.add 'hover'
    if @fireInteractiveEvent('hover', e) then @fire 'hover', e


  ###*
  # Private method called when a native mouse leave event is detected. This
  # enter event is used to trigger a corresponding `leave` event, signalling
  # the end of a hover.
  #
  # @method _mouseleave
  # @memberof stout-ui/interactive/InteractiveView#
  ###
  _mouseleave: (e) =>
    @_hoverTimer = setTimeout =>
      @._state = STATE.DEFAULT
      @prefixedClasses.remove 'hover'
      if @fireInteractiveEvent('leave', e) then @fire 'leave', e
    , 10


  ###*
  # Called when a native mouse up event is detected on the active target
  # element.
  #
  # @method _mouseup
  # @memberof stout-ui/interactive/InteractiveView#
  ###
  _mouseup: (e) =>
    @prefixedClasses.remove 'active'
    if @getHoverTarget().contains e.target
      @fire 'click'


  ###*
  # Called when a "tap" event it triggered.
  #
  # @method _tap
  # @memberof stout-ui/interactive/InteractiveView#
  ###
  _tap: (e) =>
    if @fireInteractiveEvent('tap', e) then @fire 'tap', e


  ###*
  # Removes all attached DOM event listeners and calls the parent `destroy()`
  # method.
  #
  # @method destroy
  # @memberof stout-ui/interactive/InteractiveView#
  ###
  destroy: ->
    @_removeInteractiveEventListeners()
    super()


  ###*
  # Method used to determine if an interactive event should be fired. By
  # default this method simply checks if the UI component has an `enabled`
  # attribute, and if it is `true`. If it does not have an `enabled` attribute
  # or it does and the value is `true`, the event is fired.
  #
  # This method can be overriden by extending classes for more advanced
  # functionality.
  #
  # @param {string} name - The name of the event to be fired.
  #
  # @param {Event} event - The browser-fired DOM event.
  #
  # @method fireInteractiveEvent
  # @memberof stout-ui/interactive/InteractiveView#
  # @protected
  ###
  fireInteractiveEvent: (name, event) -> not (@enabled? and not @enabled)


  ###*
  # Returns the target element that should trigger active events. By
  # default it returns the component's root element.
  #
  # @method getActiveTarget
  # @memberof stout-ui/interactive/InteractiveView#
  # @protected
  ###
  getActiveTarget: -> @root


  ###*
  # Returns the target element that should trigger focus and blur events. By
  # default it returns the component's root element.
  #
  # @method getFocusTarget
  # @memberof stout-ui/interactive/InteractiveView#
  # @protected
  ###
  getFocusTarget: -> @root


  ###*
  # Returns the target element that should trigger hover and mouse events. By
  # default it returns the component's root element.
  #
  # @method getHoverTarget
  # @memberof stout-ui/interactive/InteractiveView#
  # @protected
  ###
  getHoverTarget: -> @root


  ###*
  # Renders this component and adds approriate event listeners for hover events.
  #
  # @returns {HTMLElement} The rendered root HTML DOM node.
  #
  # @method render
  # @memberof stout-ui/interactive/InteractiveView#
  ###
  render: ->
    super().then => @_addInteractiveEventListeners()
