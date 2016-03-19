###*
# @overview Defines the view model portion of a Stout UI component in its MVVM
# architecture.
#
# @module stout-ui/component/Component
###

ComponentView = require './ComponentView'
Promise       = require 'stout-core/promise/Promise'
ViewModel     = require 'stout-client/view/ViewModel'



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


###*
# Generating function for transition methods.
#
# @private
###
makeTransitionFunction = (event) ->
  ((e) ->
    (time) ->
      promise = new Promise()
      @fire e, {time, promise}
      promise
  )(event)


###*
# Generating function for visibility methods.
#
# @private
###
makeVisibilityFunction = (event) ->
  ((e) ->
    ->
      promise = new Promise()
      @fire e, {promise}
      promise
  )(event)



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
# @exports stout-ui/component/Component
# @extends stout-client/view/ClientViewModel
# @constructor
###
module.exports = class Component extends ViewModel

  constructor: (init, events = []) ->
    super init, events.concat [
      'show', 'hide', 'transition:in', 'transition:out']


  ###*
  # Member indicating the visibility state of this component. The value of this
  # property is updated asynchronously by this view model's view.
  #
  # @member {boolean} hidden
  # @memberof stout-ui/component/Component
  ###
  @property 'visibility',
    default: 'unrendered'
    values: [
      'unrendered'
      'visible'
      'hidden'
      'transitioning:in'
      'transitioning:out'
    ]


  ###*
  # Hides the associated view.
  #
  # @returns {module:stout-core/promise/Promise} Promise fulfilled when the
  # hide is complete.
  #
  # @method hide
  # @memberof stout-ui/component/Component
  ###
  hide: makeVisibilityFunction('hide')


  ###*
  # Shows the associated view.
  #
  # @returns {module:stout-core/promise/Promise} Promise fulfilled when the
  # show is complete.
  #
  # @method show
  # @memberof stout-ui/component/Component
  ###
  show: makeVisibilityFunction('show')


  ###*
  # Initiates a transition-in on the assocated view.
  #
  # @param {number} [time] - Optional amount of time the transition should
  # take to execute.
  #
  # @param {function} [callback] - Optional callback function invoked when the
  # transition is complete.
  #
  # @returns {module:stout-core/promise/Promise} Promise fulfilled when the
  # transition is complete, or rejected if the transition is canceled.
  #
  # @method transitionIn
  # @memberof stout-ui/component/Component
  ###
  transitionIn:  makeTransitionFunction('transition:in')


  ###*
  # Initiates a transition-out on the assocated view.
  #
  # @param {number} [time] - Optional amount of time the transition should
  # take to execute.
  #
  # @returns {module:stout-core/promise/Promise} Promise fulfilled when the
  # transition is complete, or rejected if the transition is canceled.
  #
  # @method transitionOut
  # @memberof stout-ui/component/Component
  ###
  transitionOut: makeTransitionFunction('transition:out')
