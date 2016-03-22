

ComponentView = require '../component/ComponentView'


module.exports = class InteractiveView extends ComponentView


  constructor: ->
    super arguments...

    contextEvents =
      'show': @show
      'hide': @hide
      'transition:in': @transitionIn
      'transition:out': @transitionOut

    for event, handler of contextEvents
      @context.on event, (e) =>
        handler.call @, e.data.promise, e.data.time
      , @

    @_interactiveEventListeners = []


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
    fn = => @_interactiveEventListeners.push @addEventListenerTo arguments...
    fn at, 'mousedown', @mousedown
    fn at, 'mouseup', @mouseup
    fn ht, 'mouseenter', @mouseenter
    fn ht, 'mouseleave', @mouseleave
    fn ft, 'focus', @focus
    fn ft, 'blur', @blur


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
  # Called when a native blur event is detected on the hover target element.
  #
  # @method blur
  # @memberof stout-ui/interactive/InteractiveView#
  ###
  blur: (e) =>
    if @fireInteractiveEvent('blur', e)
      @prefixedClasses.remove 'focus'
      @fire 'blur', e


  ###*
  # Called when a native focus event is detected on the hover target element.
  # If this Interactive is enabled, a corresponding `focus` event is fired.
  #
  # @method focus
  # @memberof stout-ui/interactive/InteractiveView#
  ###
  focus: (e) =>
    if @fireInteractiveEvent('focus', e)
      @prefixedClasses.add 'focus'
      @fire 'focus', e


  ###*
  # Called when a native mouse down event is detected on the hover target
  # element. If this Interactive is enabled, a corresponding `active` event
  # is fired.
  #
  # @method mousedown
  # @memberof stout-ui/interactive/InteractiveView#
  ###
  mousedown: (e) =>
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
  # @method mouseenter
  # @memberof stout-ui/interactive/InteractiveView#
  ###
  mouseenter: (e) =>
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
  # @method mouseleave
  # @memberof stout-ui/interactive/InteractiveView#
  ###
  mouseleave: (e) =>
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
  # @method mouseup
  # @memberof stout-ui/interactive/InteractiveView#
  ###
  mouseup: (e) =>
    @prefixedClasses.remove 'active'
    if @getHoverTarget().contains e.target
      @fire 'click'


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
  render: (promise) ->
    super(promise).then => @_addInteractiveEventListeners()
