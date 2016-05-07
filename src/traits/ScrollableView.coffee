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


wheelTimer = null


WHEEL_TIME = 100


###*
# Maximum scrollable height.
#
#
###
max = Infinity



min = 0



offset = 0


reference = 0


startScrolling = (e) ->
  scrolling = true
  reference = ypos e
  max = parseInt(getComputedStyle(@root.firstChild).height) - window.innerHeight


stopScrolling = ->
  scrolling = false


###*
# `touchstart` handler for scrollable view.
#
#
###
onTouchStart = (e) ->
  startScrolling.call @, e
  e.preventDefault()
  e.stopPropagation()
  return



###*
# `touchend` handler for scrollable view.
#
#
###
onTouchEnd = (e) ->
  stopScrolling()
  e.preventDefault()
  e.stopPropagation()
  return



###*
# `touchmove` handler for scrollable view.
#
#
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



onWheel = (e) ->
  if wheelTimer then clearTimeout wheelTimer

  if not scrolling then startScrolling.call @, e

  wheelTimer = setTimeout ->
    stopScrolling()
  , WHEEL_TIME

  onMove.call @, e




scroll = (y) ->
  if y > max
    offset = max
  else if y < min
    offset = min
  else
    offset = y
  prefix @root.firstChild, 'transform', "translateY(#{-offset}px)"



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
    console.log 'initting!', @root
    @classes.add SCROLLABLE_CLS
    @addEventListener 'touchstart', onTouchStart, @
    @addEventListener 'touchend', onTouchEnd, @
    @addEventListener 'touchmove', onMove, @
    @addEventListener 'wheel', onWheel, @
