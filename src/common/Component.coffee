$          = require 'stout-client/$'
dom        = require 'stout-core/utilities/dom'
ClientView = require 'stout-client/view/ClientView'
vars       = require '../vars'

# Load common variables.
vars.default('common', require '../vars/common')
PREFIX      = vars.read 'common/prefix'
HIDDEN_CLS  = vars.read 'common/hidden'
VISIBLE_CLS = vars.read 'common/visible'


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

    # Hide and show callback timer.
    @_timer = null

    @classes.add PREFIX + 'component'


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

  show: ->
    if @rendered
      @prefixedClasses.remove HIDDEN_CLS
      @prefixedClasses.add VISIBLE_CLS
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
    if @rendered
      @prefixedClasses.remove VISIBLE_CLS
      @prefixedClasses.add HIDDEN_CLS
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
