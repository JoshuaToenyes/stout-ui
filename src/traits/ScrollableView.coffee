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
# The class applied to the scrollable's viewport area.
#
# @const {string}
# @private
###
VIEWPORT_CLS = vars.readPrefixed 'scrollable/scrollable-viewport-class'


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
WHEEL_TIME = 30


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


velocity = 0

amplitude = 0

frame = 0

target = 0

scrollTimestamp = null

scrollTicker = null

TICK_INTERVAL = 30

T_CONST = 325

ELASTIC_CONST = 0.55
AMPLITUDE_CONST = 0.7
MAX_EDGE_VELOCITY = 450

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
  refHeight = parseInt(getComputedStyle(@viewport.firstChild).height)
  max = refHeight - window.innerHeight
  return


startKineticScrolling = ->
  velocity = amplitude = 0
  frame = offset
  scrollTimestamp = Date.now()
  clearInterval scrollTicker
  scrollTicker = setInterval track, TICK_INTERVAL


track = ->
  now = Date.now()
  elapsed = now - scrollTimestamp
  scrollTimestamp = now
  delta = offset - frame
  frame = offset
  v = 1000 * delta / (1 + elapsed)
  velocity = 0.8 * v + 0.2 * velocity



###*
# Stops view scrolling.
#
# @function stopScrolling
# @inner
###
stopScrolling = ->
  scrolling = false



stopKineticScrolling = ->
  clearInterval scrollTicker

  amplitude = AMPLITUDE_CONST * velocity
  target = Math.round(offset + amplitude)

  if target < min
    target = min
  else if target > max
    target = max

  if target is min or target is max
    pv = velocity
    velocity = Math.min Math.abs(velocity), MAX_EDGE_VELOCITY
    if pv < 0 then velocity *= -1
    amplitude = AMPLITUDE_CONST * velocity

  scrollTimestamp = Date.now()
  requestAnimationFrame => autoScroll.call @


autoScroll = ->
  if amplitude
    elapsed = Date.now() - scrollTimestamp
    delta = -amplitude * Math.exp(-elapsed / T_CONST)

    if Math.abs(delta) > 0.5

      if target is min or target is max
        t = target - delta
      else
        t = target + delta

      scroll.call @, t
      requestAnimationFrame => autoScroll.call @
    else
      scroll.call @, target


###*
# `touchstart` handler starts scrolls initiated by a touch event.
#
# @param {TouchEvent} e - The touch event which initated the scroll.
#
# @function onTouchStart
###
onTouchStart = (e) ->
  startScrolling.call @, e
  startKineticScrolling.call @
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
  stopScrolling.call @
  stopKineticScrolling.call @
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
    if Math.abs(delta) > 2
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
  if not scrolling
    startScrolling.call @, e
    startKineticScrolling.call @, e
  wheelTimer = setTimeout =>
    onMove.call @, e
    stopScrolling.call @
    stopKineticScrolling.call @
  , WHEEL_TIME
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
  c = ELASTIC_CONST
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
  prefix @viewport.firstChild, 'transform', "translateY(#{-offset}px)"
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

  @property 'viewport',
    get: ->
      @select(".#{VIEWPORT_CLS}") or @root


  ###*
  # Initialize this trait ...
  #
  # @method initTrait
  # @memberof stout-ui/traits/ScrollableView#
  # @private
  ###
  initTrait: ->
    @classes.add SCROLLABLE_CLS
    @viewClasses.scrollableViewport = VIEWPORT_CLS
    @addEventListener 'touchstart', onTouchStart, @
    @addEventListener 'touchend', onTouchEnd, @
    @addEventListener 'touchmove', onMove, @
    @addEventListener 'wheel', onWheel, @
