###*
# @overview Defines the `Interactive` class, an abstract UI component class
# which defines a component meant to be interacted with by the user.
#
# @module stout-ui/interactive/Interactive
###

Component  = require './Component'
nextTick = require 'stout-client/util/nextTick'


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
    set: (handler) ->
      switch typeof handler
        when 'string'
          nextTick => @on 'click', @scope.$member[handler] or @scope[handler]
        when 'function'
          nextTick => @on 'click', handler
