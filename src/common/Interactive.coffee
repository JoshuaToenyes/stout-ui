###*
# @overview Defines the `Interactive` class, an abstract UI component class
# which defines a component meant to be interacted with by the user.
#
# @module stout-ui/interactive/Interactive
###

Component  = require './Component'


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



module.exports = class Interactive extends Component

  ###*
  # The Interactive class is an abstract UI component class which defines a
  # UI element that the user can interact with. It abstracts away common UI
  # events and puts them into the Stout paradigm by defining basic Stout
  # events for common UI interactions such as `hover`, `active`, and `focus`.
  #
  # @param {function} template - The template function to use for creating the
  # HTML for this element.
  #
  # @param {Model} [model] - The model associated with this view.
  #
  # @param {Object} [opts={}] - Options object.
  #
  # @param {Object} [init={}] - Property initiation parameters.
  #
  # @param {Array.<string>} [events=[]] - Events to immediately register.
  #
  # @fires "hover"
  # @fires "leave"
  # @fires "active"
  # @fires "focus"
  #
  # @exports stout-ui/interactive/Interactive
  # @constructor
  ###
  constructor: (template, model, opts, init, events = []) ->
    super template, model, opts, init, [
      'blur'
      'hover'
      'leave'
      'active'
      'focus'].concat events
    @_hoverTimer = null
    @_disabled = false
    @_state = STATE.DEFAULT


  ###*
  # Alias method to easily add a click handler to this Interactive element.
  #
  ###
  @property 'click',
    serializable: false
    set: (fn) ->
      if not fn then return
      setTimeout =>
        @on 'click', fn
      , 0


  ###*
  # Called when a native blur event is detected on the hover target element.
  #
  # @method _onBlur
  # @private
  ###
  _onBlur: (e) =>
    if @fireInteractiveEvent('blur', e)
      @prefixedClasses.remove 'focus'
      @fire 'blur', e


  ###*
  # Called when a native click event is detected on the hover target element.
  # If this Interactive is enabled, a corresponding `click` event is fired.
  #
  # @method _onClick
  # @private
  ###
  _onClick: (e) =>
    if @fireInteractiveEvent('click', e) then @fire 'click', e


  ###*
  # Called when a native focus event is detected on the hover target element.
  # If this Interactive is enabled, a corresponding `focus` event is fired.
  #
  # @method _onFocus
  # @private
  ###
  _onFocus: (e) =>
    if @fireInteractiveEvent('focus', e)
      @prefixedClasses.add 'focus'
      @fire 'focus', e


  ###*
  # Called when a native mouse down event is detected on the hover target
  # element. If this Interactive is enabled, a corresponding `active` event
  # is fired.
  #
  # @method _onMouseDown
  # @private
  ###
  _onMouseDown: (e) =>
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
  # @method _onMouseEnter
  # @private
  ###
  _onMouseEnter: (e) =>
    clearTimeout @_hoverTimer
    if @_state is STATE.HOVER then return
    @_state = STATE.HOVER
    @prefixedClasses.add 'hover'
    if @fireInteractiveEvent('hover', e) then @fire 'hover', e


  ###*
  # Private method called when a native mouse leave event is detected. This
  # enter event is used to trigger a corresponding `leave` event, signalling
  # the end of a hover.
  #
  # @method _onMouseLeave
  # @private
  ###
  _onMouseLeave: (e) =>
    self = @
    @_hoverTimer = setTimeout =>
      self._state = STATE.DEFAULT
      @prefixedClasses.remove 'hover'
      if @fireInteractiveEvent('leave', e) then self.fire 'leave', e
    , 10


  ###*
  # Called when a native mouse up event is detected on the active target
  # element.
  #
  # @method _onMouseDown
  # @private
  ###
  _onMouseUp: (e) =>
    @prefixedClasses.remove 'active'


  ###*
  # Removes all attached DOM event listeners and calls the parent `destroy()`
  # method.
  #
  # @method destroy
  # @public
  ###
  destroy: ->
    a = @getActiveTarget()
    a.removeEventListener 'mousedown', @_onMouseDown
    a.removeEventListener 'mouseup', @_onMouseUp

    b = @getHoverTarget()
    b.removeEventListener 'click', @_onClick
    b.removeEventListener 'mouseenter', @_onMouseEnter
    b.removeEventListener 'mouseleave', @_onMouseLeave

    f = @getFocusTarget()
    f.removeEventListener 'focus', @_onFocus
    f.removeEventListener 'blur', @_onBlur

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
  # @memberof stout-ui/interactive/Interactive#
  # @protected
  ###
  fireInteractiveEvent: (name, event) -> not (@enabled? and not @enabled)


  ###*
  # Renders this component and adds approriate event listeners for hover events.
  #
  # @returns {HTMLElement} The rendered root HTML DOM node.
  #
  # @method render
  # @public
  ###
  render: ->
    super()

    a = @getActiveTarget()
    a.addEventListener 'mousedown', @_onMouseDown
    a.addEventListener 'mouseup', @_onMouseUp

    b = @getHoverTarget()
    b.addEventListener 'click', @_onClick
    b.addEventListener 'mouseenter', @_onMouseEnter
    b.addEventListener 'mouseleave', @_onMouseLeave

    f = @getFocusTarget()
    f.addEventListener 'focus', @_onFocus
    f.addEventListener 'blur', @_onBlur

    @root


  ###*
  # Returns the target element that should trigger active events. By
  # default it returns the component's root element.
  #
  # @method getActiveTarget
  # @protected
  ###
  getActiveTarget: -> @root


  ###*
  # Returns the target element that should trigger focus and blur events. By
  # default it returns the component's root element.
  #
  # @method getFocusTarget
  # @protected
  ###
  getFocusTarget: -> @root


  ###*
  # Returns the target element that should trigger hover and mouse events. By
  # default it returns the component's root element.
  #
  # @method getHoverTarget
  # @protected
  ###
  getHoverTarget: -> @root
