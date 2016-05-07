###*
# @overview Defines the `ScrollableView` trait ...
#
# @module stout-ui/traits/ScrollableView
###
Foundation = require 'stout-core/base/Foundation'
prefix     = require 'stout-client/util/prefix'
vars       = require '../vars'

# Load content variables.
require '../vars/scrollable'


###*
# The class added to scrollable views.
#
# @const {string}
# @private
###
SCROLLABLE_CLS = vars.readPrefixed 'scrollable/scrollable-class'


###*
# Inner boolean flag indicating that scrolling is in-progress. Only one is
# required because the user isn't able to scroll multiple scollables
# simultaneously.
#
# @type boolean
###
scrolling = false


###*
# Timer used for stopping scroll wheel initated scrolls.
#
#
###
wheelTimer = null


###*
# The time to wait before ending a scroll initiated by the scroll wheel.
#
# @const {number}
# @inner
###
WHEEL_TIME = 100


###*
# Maximum scrollable height.
#
# @type number
###
max = Infinity


###*
# The minimum offset.
#
# @type number
###
min = 0


###*
# The scrollable view's current translation offset.
#
# @type number
###
offset = 0


###*
# The reference 'y' position, used between scroll events to track the distance
# scrolled.
#
# @type number
# @inner
###
reference = 0


###*
# The calculated height of the scrollable view.
#
# @type number
# @inner
###
refHeight = 0


###*
# Start the view scrolling.
#
# @param {Event} e - The event which started scroll.
#
# @function startScrolling
# @inner
###
startScrolling = (e) ->
  scrolling = true
  reference = ypos e
  refHeight = parseInt(getComputedStyle(@root.firstChild).height)
  max = refHeight - window.innerHeight
  return


###*
# Stops view scrolling.
#
# @function stopScrolling
# @inner
###
stopScrolling = ->
  scrolling = false


###*
# `touchstart` handler starts scrolls initiated by a touch event.
#
# @param {TouchEvent} e - The touch event which initated the scroll.
#
# @function onTouchStart
###
onTouchStart = (e) ->
  startScrolling.call @, e
  e.preventDefault()
  e.stopPropagation()
  return


###*
# `touchend` handler ends scrolls initiated by a touch event.
#
# @param {TouchEvent} e - The touchend event.
#
# @function onTouchEnd
###
onTouchEnd = (e) ->
  stopScrolling()
  e.preventDefault()
  e.stopPropagation()
  return


###*
# The scroll movement handler. This method handled `touchmove` or `wheel`
# events.
#
# @param {Event} e - The movement event.
#
# @function onMove
###
onMove = (e) ->
  if scrolling
    y = ypos(e)
    delta = reference - y
    if Math.abs(delta) > 3
      reference = y
      scroll.call @, offset + delta
  e.preventDefault()
  e.stopPropagation()
  return


###*
# Wheel event handler. This method handled receives "wheel" events and initiates
# view scrolling accordingly.
#
# @param {Event} e - The wheel event.
#
# @function onWheel
###
onWheel = (e) ->
  if wheelTimer then clearTimeout wheelTimer
  if not scrolling then startScrolling.call @, e
  wheelTimer = setTimeout (-> stopScrolling.call @), WHEEL_TIME
  onMove.call @, e


###*
# Calculates elastic "bounce" effect at scroll view edges.
#
# @param {number} y - The current scroll position.
#
# @param {number} limit - The limit of the scroll view, or the current edge the
# user is hitting.
#
# @returns {number} The new scroll position or offset.
#
# @function elastic
# @inner
###
elastic = (y, limit) ->
  # * x = distance from the edge
  # * c = constant value, UIScrollView uses 0.55
  # * d = dimension, either width or height
  x = Math.abs(limit - y)
  c = 0.55
  d = refHeight
  b = (1 - (1 / ((x * c / d) + 1.0))) * d
  -b


###*
# Handles actually scrolling the view by obtaining the correct offset and
# translating the view accordingly.
#
# @param {number} y - The new scroll offset.
#
# @function scroll
# @inner
###
scroll = (y) ->
  if y > max
    offset = y + elastic y, max
  else if y < min
    offset = elastic y, min
  else
    offset = y
  prefix @root.firstChild, 'transform', "translateY(#{-offset}px)"
  return


###*
# Extracts and returns the "y position" of a movement event.
#
# @param {Event} e - The wheel or touch event which "scrolled" the view.
#
# @returns {number} The new "y position."
###
ypos = (e) ->
  if e.targetTouches
    e.targetTouches[0].clientY
  else if e instanceof WheelEvent
    reference - e.deltaY



###*
# The `ScrollableView` ...
#
# @exports stout-ui/traits/ScrollableView
# @mixin
###
module.exports = class ScrollableView extends Foundation


  ###*
  # Initialize this trait ...
  #
  # @method initTrait
  # @memberof stout-ui/traits/ScrollableView#
  # @private
  ###
  initTrait: ->
    @classes.add SCROLLABLE_CLS
    @addEventListener 'touchstart', onTouchStart, @
    @addEventListener 'touchend', onTouchEnd, @
    @addEventListener 'touchmove', onMove, @
    @addEventListener 'wheel', onWheel, @
