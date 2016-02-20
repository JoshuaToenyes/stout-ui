$          = require 'stout-client/$'
dom        = require 'stout-core/utilities/dom'
ClientView = require 'stout-client/view/ClientView'
vars       = require '../vars'

# Load common variables.
vars.default('common', require '../vars/common')
PREFIX        = vars.read 'common/prefix'
HIDDEN_CLS    = vars.read 'common/hidden'
VISIBLE_CLS   = vars.read 'common/visible'
TRANS_CLS     = vars.read 'common/transitioning'
TRANS_IN_CLS  = vars.read 'common/transitioning-in'
TRANS_OUT_CLS = vars.read 'common/transitioning-out'


makeTransitionFunc = (func, transitionClass, removeClass, test) ->
  (t = 0, cb) ->
    setTimeout =>
      if @rendered and test.call @
        @prefixedClasses.remove VISIBLE_CLS, HIDDEN_CLS, removeClass
        @prefixedClasses.add TRANS_CLS, transitionClass
        clearTimeout @_transitionTimer
        @_transitionTimer = setTimeout =>
          @[func] cb
        , t
    , 0
    @


##
# Component class which represents a client-side component that exists in
# the users web browser.
#
# @class Component

module.exports = class Component extends ClientView

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


  ##
  # Component constructor creates a new component instance and passes all
  # arguments to the parent ClientView class.
  #
  # @see stout/client/view/ClientView#constructor
  #
  # @constructor

  constructor: ->
    super arguments...

    @prefix = PREFIX

    ###*
    # Internal reference to transition timers to prevent calling callbacks
    # incorrectly...
    # @private
    ###
    @_transitionTimer = null

    @classes.add PREFIX + 'component'


  transitionIn: makeTransitionFunc 'show', TRANS_IN_CLS, TRANS_OUT_CLS, ->
    @hidden or @transitioningOut


  transitionOut: makeTransitionFunc 'hide', TRANS_OUT_CLS, TRANS_IN_CLS, ->
    @visible or @transitioningIn


  _removeTransitionClasses: ->
    @prefixedClasses.remove TRANS_CLS, TRANS_IN_CLS, TRANS_OUT_CLS


  _stopTransition: ->
    clearTimeout @_transitionTimer
    @_removeTransitionClasses()


  ##
  # Fades this component into view. By default, this method simply removes the
  # `sc-hidden` class from the element returned by `_getHideTarget()`. This
  # behavior may be overriden by extending classes for more complex
  # functionality. If the component is already visible or not rendered, calling
  # this method has no effect.
  #
  # @param {function} [cb] - Callback function executed when the component is
  # fully visible.
  #
  # @method show
  # @public

  show: (cb) ->
    setTimeout =>
      if @rendered
        @_stopTransition()
        @prefixedClasses.remove HIDDEN_CLS
        @prefixedClasses.add VISIBLE_CLS
        cb?.call null
    , 0
    @


  ##
  # Fades this component from view. By default, this method add the `sc-hidden`
  # class to the element returned by `_getHideTarget()`. This behavior may be
  # overriden by extending classes for more complex functionality. If the
  # component is already hidden or not rendered calling this method has no
  # effect.
  #
  # @param {function} [cb] - Callback function executed when the component is
  # hidden.
  #
  # @method hide
  # @public

  hide: (cb) ->
    setTimeout =>
      if @rendered
        @_stopTransition()
        @prefixedClasses.remove VISIBLE_CLS
        @prefixedClasses.add HIDDEN_CLS
        cb?.call null
    , 0
    @


  ##
  # Renders this component and adds the `sc-component` class to the root
  # element.
  #
  # @returns {HTMLElement} The root component element.
  #
  # @method render
  # @public
  render: ->
    super()
    @el
