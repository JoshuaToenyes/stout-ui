###*
# @overview Defines the `fillable` trait, which makes an element capable of
# being "filled" with ink for a nice hide/show and transition effects.
# @module stout-ui/fill/fillable
###

# Require necessary shared variables.
require '../vars/fill'


###*
# The container class which fill-container element should have applied.
# @type string
# @const
# @private
###
CONTAINER_CLS = vars.readPrefixed 'fill/fill-container-class'


###*
# The class attached to a container element indicating it is filled.
# @type string
# @const
# @private
###
FILLED_CLS = vars.readPrefixed 'fill/filled-class'


###*
# The fill trait can be used by UI components to "fill" some container with
# an expanding ink effect.
#
# @exports stout-ui/fill/fillable
# @mixin
###
module.exports =

  ###*
  # Fills the container with ink. If there is already ink in the passed
  # container this method does nothing.
  #
  # @param {DOMElement} [container] - The container to fill. If one is not
  # specified, then the container with the default fill container class is used.
  #
  # @param {function} [cb] - Optional callback function to call when the
  # container is filled.
  #
  # @param {number} [t] - The amount of time (in milliseconds) it should take
  # to fill the container. If not specified (normal usage) the callback
  # function is called after the ink fill has complete, the time this takes is
  # dynamically calculated by the `inkable` trait, based on the size of the
  # container element.
  #
  # @param {boolean} force - Force-fills the container, regardless of if there
  # is ink already present.
  #
  # @method _fill
  # @memberof stout-ui/fill/fillable#
  # @private
  ###
  _fill: (container, cb, t, force = false) ->
    if not container then container = @getFillContainer()
    if @hasInk(container) and not force then return
    r = container.getBoundingClientRect()
    @expandInk container, r.width / 2, r.height / 2, r.width, r.height, t, ->
      container.classList.add FILLED_CLS
      cb?.call null


  ###*
  # Immediately removes all ink from the fill container.
  #
  # @param {DOMElement} [container] - The container to fill. If one is not
  # specified, then the container with the default fill container class is used.
  #
  # @method emptyFill
  # @memberof stout-ui/fill/fillable
  ###
  emptyFill: (container) ->
    @removeInk container or @getFillContainer()


  ###*
  # Fills the container with ink. If there is already ink in the passed
  # container this method does nothing.
  #
  # @param {DOMElement} [container] - The container to fill. If one is not
  # specified, then the container with the default fill container class is used.
  #
  # @param {function} [cb] - Optional callback function to call when the
  # container is filled.
  #
  # @method fill
  # @memberof stout-ui/fill/fillable#
  ###
  fill: (container, cb) ->
    @_fill container, cb, null, false


  ###*
  # Fills the container with ink, regardless of whether or not it already
  # contains ink.
  #
  # @param {DOMElement} [container] - The container to fill. If one is not
  # specified, then the container with the default fill container class is used.
  #
  # @param {function} [cb] - Optional callback function to call when the
  # container is filled.
  #
  # @method fill
  # @memberof stout-ui/fill/fillable#
  ###
  forceFill: (container, cb) ->
    @_fill container, cb, null, true


  ###*
  # Returns `true` if the container element is fully filled.
  #
  # @param {DOMElement} [container] - The container to check. If not specified,
  # then the container with the default fill container class applied is used.
  #
  # @returns {boolean} `true` if fully filled.
  #
  # @method filled
  # @memberof stout-ui/fill/fillable#
  ###
  filled: (container) ->
    if not container then container = @getFillContainer()
    container.classList.contains FILLED_CLS


  ###*
  # Immediately fills the container with ink, essentially eliminating the
  # "filling" effect of the ink.
  #
  # @param {DOMElement} [container] - The container to fill. If one is not
  # specified, then the container with the default fill container class is used.
  #
  # @param {function} [cb] - Optional callback function to call when the
  # container is filled.
  #
  # @method fillNow
  # @memberof stout-ui/fill/fillable#
  ###
  fillNow: (container, cb) ->
    @_fill container, cb, 0, false


  ###*
  # Returns the fill container element.
  #
  # @returns {DOMElement} The fill container
  #
  # @method getFillContainer
  # @memberof stout-ui/fill/fillable#
  ###
  getFillContainer: -> @select ".#{CONTAINER_CLS}"


  ###*
  # Inititates the object using this trait. This method is not added to objects
  # using this trait.
  #
  # @method init
  # @memberof stout-ui/fill/fillable#
  ###
  init: ->
    @viewClasses.fillContainer = CONTAINER_CLS


  ###*
  # Removes ink from the passed container element. If there is no ink in the
  # container, then this method does nothing.
  #
  # @param {DOMElement} container - The container to empty.
  #
  # @param {function} [cb] - Optional callback function to call when the
  # container has been unfilled.
  #
  # @method unfill
  # @memberof stout-ui/fill/fillable#
  ###
  unfill: (container, cb) ->
    if not container then container = @getFillContainer()
    ink = @getInk container
    if ink.length > 0
      @fadeInk ink, 0, ->
        container.classList.remove FILLED_CLS
        cb?.call null
    else
      cb?.call null
