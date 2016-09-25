###*
# @overview Defines the `Interactive` class, an abstract UI component class
# which defines a component meant to be interacted with by the user.
#
# @module stout-ui/interactive/Interactive
###

Component  = require '../component/Component'
nextTick = require 'stout-client/util/nextTick'






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
  constructor: (init, events = []) ->
    super init, events.concat [
      'blur', 'focus', 'active', 'hover', 'click', 'leave']


  ###*
  # Flag indicating if the user has visited component. A component which has
  # been "visited" has been focused then blurred.
  #
  # @member {boolean} visited
  # @memberof stout-ui/interactive/InteractiveView
  ###
  @property 'visited',
    default: false
    type: 'boolean'
