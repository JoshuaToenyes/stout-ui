#require 'fill/fill.sass'
#commonSASS = require '!!sass-variables!vars/common.sass'
#fillSASS = require '!!sass-variables!vars/fill.sass'

prefix = 'ui-' #commonSASS.prefix
filledClass = prefix + 'filled' # fillSASS.filledPostfix

require '../vars/fill'

###*
# The container classname which will hold the ink fill inside the radio button.
# @type string
# @const
# @private
###
FILL_CLS = vars.readPrefixed 'fill/fill-container-class'

module.exports =

  # Returns `true` if the container element is fully filled.
  #
  # @param {DOMElement} container - The container to check.
  #
  # @returns {boolean} `true` if fully filled.
  #
  # @method filled
  # @public

  filled: (container) ->
    container.classList.contains filledClass


  # Fills the passed container with ink. If there is already ink in the passed
  # container this method does nothing.
  #
  # @param {DOMElement} container - The container to fill.
  #
  # @param {function} [cb] - Optional callback function to call when the
  # container is filled.
  #
  # @method fill
  # @public

  fill: (container, cb, t) ->
    if not container then container = @_getFillContainer()
    if @hasInk(container) then return
    r = container.getBoundingClientRect()
    @expandInk container, r.width / 2, r.height / 2, r.width, r.height, t, ->
      container.classList.add filledClass
      cb?.call null


  fillNow: (container, cb) ->
    @fill container, cb, 1


  # Returns the ink fill container for showing/hiding the button.
  #
  # @returns {DOMElement} The fill container
  #
  # @method _getFillContainer
  # @private

  _getFillContainer: -> @select ".#{FILL_CLS}"


  # Removes ink for the passed container element. If there is no ink in the
  # container, then this method does nothing.
  #
  # @param {DOMElement} container - The container to empty.
  #
  # @param {function} [cb] - Optional callback function to call when the
  # container has been unfilled.
  #
  # @method unfill
  # @public

  unfill: (container, cb) ->
    ink = @getInk container
    if ink.length > 0 then @fadeInk ink[0], 0, ->
      container.classList.remove filledClass
      cb?.call null
