###*
# @overview Defines a common UI component.
#
# @module stout-ui/common/Component
###

ClientViewModel = require 'stout-client/view/ClientViewModel'
vars       = require '../vars'


# Load common variables.
require '../vars/common'


PREFIX        = vars.read 'common/prefix'
HIDDEN_CLS    = vars.read 'common/hidden'
VISIBLE_CLS   = vars.read 'common/visible'
TRANS_CLS     = vars.read 'common/transitioning'
TRANS_IN_CLS  = vars.read 'common/transitioning-in'
TRANS_OUT_CLS = vars.read 'common/transitioning-out'

###*
# Inner transition function factory.
#
# @param {function} func - The function to call after the transition has
# finished.
#
# @param {string} transitionClass - The class to apply to the component's root
# element while the transition is occurring.
#
# @param {string} removeClass - The class to remove while the transition is
# underway.
#
# @param {string} event - The name of the event to fire when the transition is
# initiated.
#
# @param {function} test - Test function which should return `true` or `false`
# to indicate if the transition should be allowed occur.
#
# @function stout-ui/common/Component~makeTransitionFunc
# @inner
###
makeTransitionFunc = (func, transitionClass, removeClass, event, test) ->
  (t = 0, cb) ->
    setTimeout =>
      if @rendered and test.call @
        @prefixedClasses.remove VISIBLE_CLS, HIDDEN_CLS, removeClass
        @prefixedClasses.add TRANS_CLS, transitionClass
        clearTimeout @_transitionTimer
        @_transitionTimer = setTimeout =>
          @[func] cb
        , t
        @fire event
    , 10
    @


###*
# Fired when the component is shown.
#
# @event "show"
# @type stout-core/event/Event
###


###*
# Fired when the component is hidden.
#
# @event "hide"
# @type stout-core/event/Event
###


###*
# Event fired when a transition-in has been initiated.
#
# @event "transition:in"
# @type stout-core/event/Event
###


###*
# Event fired when a transition-out has been initiated.
#
# @event "transition:out"
# @type stout-core/event/Event
###


module.exports = class Component extends ClientViewModel

  ###*
  # The Component class represents a Stout UI element.
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
  # @fires "show"
  # @fires "hide"
  # @fires "transition:in"
  # @fires "transition:out"
  #
  # @exports stout-ui/common/Component
  # @extends stout-client/view/ClientViewModel
  # @constructor
  ###
  constructor: (template, model, opts, init, events = []) ->
    super template, model, opts, init, events.concat [
      'show', 'hide', 'transition:in', 'transition:out']

    @prefix = PREFIX

    ###*
    # Internal reference to transition timers to prevent calling callbacks
    # incorrectly...
    # @private
    ###
    @_transitionTimer = null

    @classes.add PREFIX + 'component'


  ##
  # This property is `true` if this component is currently hidden.
  #
  # @property {boolean} hidden
  # @public

  @property 'hidden',
    serializable: false

    ##
    # Hides or shows the component based on the set boolean value.
    #
    # @setter

    set: (hidden) -> @visible = not hidden

    ##
    # Returns `true` if this component is currently hidden.
    #
    # @getter

    get: -> not @visible


  ##
  # This property is `true` if the button is currently visible, or filled.
  #
  # @property {boolean} visible
  # @public

  @property 'visible',
    serializable: false

    ##
    # Hides or shows the component based on the set boolean value.
    #
    # @setter

    set: (visible) -> if visible then @show() else @hide()

    ##
    # Returns `true` if this component is currently visible.
    #
    # @getter

    get: -> @prefixedClasses.contains VISIBLE_CLS


  @property 'transitioning',
    get: -> @prefixedClasses.contains TRANS_CLS


  @property 'transitioningIn',
    get: -> @prefixedClasses.contains TRANS_IN_CLS


  @property 'transitioningOut',
    get: -> @prefixedClasses.contains TRANS_OUT_CLS



  transitionIn: makeTransitionFunc 'show', TRANS_IN_CLS, TRANS_OUT_CLS,
  'transition:in', ->
    @hidden or @transitioningOut


  transitionOut: makeTransitionFunc 'hide', TRANS_OUT_CLS, TRANS_IN_CLS,
  'transition:out', ->
    @visible or @transitioningIn


  ###*
  # Removes all transition-related classes.
  #
  # @method _removeTransitionClasses
  # @memberof stout-ui/common/Component#
  # @private
  ###
  _removeTransitionClasses: ->
    @prefixedClasses.remove TRANS_CLS, TRANS_IN_CLS, TRANS_OUT_CLS


  ###*
  # Immediately stops an in-progress transition.
  #
  # @method _stopTransition
  # @memberof stout-ui/common/Component#
  # @private
  ###
  _stopTransition: ->
    clearTimeout @_transitionTimer
    @_removeTransitionClasses()


  ###*
  # Stops any in-progress transition and makes this component visible. If this
  # component is not rendered, calling this method has no effect.
  #
  # @param {function} [cb] - Callback function executed when the component is
  # fully visible.
  #
  # @method show
  # @memberof stout-ui/common/Component#
  # @public
  ###
  show: (cb) ->
    setTimeout =>
      if @rendered
        @_stopTransition()
        @prefixedClasses.remove HIDDEN_CLS
        @prefixedClasses.add VISIBLE_CLS
        @fire 'show'
        cb?.call null
    , 0
    @


  ###*
  # Stops any in-progress transition and hides this component. If this
  # component is not rendered, calling this method has no effect.
  #
  # @param {function} [cb] - Callback function executed when the component is
  # fully visible.
  #
  # @method hide
  # @memberof stout-ui/common/Component#
  # @public
  ###
  hide: (cb) ->
    setTimeout =>
      if @rendered
        @_stopTransition()
        @prefixedClasses.remove VISIBLE_CLS
        @prefixedClasses.add HIDDEN_CLS
        @fire 'hide'
        cb?.call null
    , 0
    @


  ###*
  # Renders this component and immediately shows it.
  #
  # @returns {HTMLElement} The root component element.
  #
  # @method render
  # @memberof stout-ui/common/Component#
  # @public
  ###
  render: ->
    super()
    @root
