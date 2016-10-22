###*
# @overview Makes a component resizable.
#
# @module stout-ui/resizable/ResizableView
###
Draggable  = require '../traits/Draggable'
Foundation = require 'stout-core/base/Foundation'
isString   = require 'lodash/isString'
vars       = require '../vars'

# Require shared variables.
require '../vars/resizable'


###*
# Class added to resizable components.
#
# @type string
# @const
# @private
###
RESIZABLE_CLASS = vars.readPrefixed 'resizable/resizable-class'


###*
# Class added to element while a resize is in-progress.
#
# @type string
# @const
# @private
###
RESIZING_CLASS = vars.readPrefixed 'resizable/resizing-class'


###*
# Class added to element when within resizable NS area.
#
# @type string
# @const
# @private
###
NS_CURSOR_CLASS = vars.readPrefixed 'resizable/resizable-cursor-ns-class'

###*
# Class added to element when within resizable EW area.
#
# @type string
# @const
# @private
###
EW_CURSOR_CLASS = vars.readPrefixed 'resizable/resizable-cursor-ew-class'

###*
# Class added to element when within resizable NESW area.
#
# @type string
# @const
# @private
###
NESW_CURSOR_CLASS = vars.readPrefixed 'resizable/resizable-cursor-nesw-class'

###*
# Class added to element when within resizable NWSE area.
#
# @type string
# @const
# @private
###
NWSE_CURSOR_CLASS = vars.readPrefixed 'resizable/resizable-cursor-nwse-class'


###*
# Tests if the passed point is with a rectangle of size `height` by `width`
# with a top-left coordinate of `top`, `left`.
#
# @param {number} x - The point's x coordinate.
#
# @param {number} y - The point's y coordinate.
#
# @param {number} top - The rectangle's top coordinate.
#
# @param {number} left - The rectangle's left coordinate.
#
# @param {number} height - The height of the rectangle.
#
# @param {number} width - The width of the rectangle.
#
# @returns {boolean} `true` if the point is within the rectangle, `false`
# otherwise.
#
# @function inRec
###
inRec = (x, y, top, left, height, width) ->
  (x >= left) and (x <= left + width) and (y >= top) and (y <= top + height)


###*
# Clamps the passed value `v` to within `min` and `max` values.
#
# @param {number} v - The value to clamp.
#
# @param {number} min - The minimum value.
#
# @param {number} max - The maximum value.
#
# @returns {number} A number between `min` and `max`.
#
# @function clamp
###
clamp = (v, min, max) -> Math.max(min, Math.min(max, v))


###*
# Handles when a resize starts (mousedown/touchstart in resize area).
#
# @param {MouseEvent|TouchEvent} e - The mouse or touch event.
#
# @this stout-ui/resizable/ResizableView#
# @function onResizeEnd
###
onResizeStart = (e) ->
  if @__resizeDir and not @classes.contains(RESIZING_CLASS)
    @fire 'resizestart', generateResizeEventData.call @, e
    bmu = @addEventListenerTo document.body, 'mouseup', onResizeEnd, @
    bte = @addEventListenerTo document.body, 'touchend', onResizeEnd, @
    bml = @addEventListenerTo document.body, 'mouseleave', onResizeEnd, @
    bmm = @addEventListenerTo document.body, 'mousemove', onResize, @
    btm = @addEventListenerTo document.body, 'touchmove', onResize, @
    @classes.add RESIZING_CLASS
    @__resizeableListeners.bmu = bmu
    @__resizeableListeners.bte = bte
    @__resizeableListeners.bml = bml
    @__resizeableListeners.bmm = bmm
    @__resizeableListeners.btm = btm


###*
# Handles when a touchstart event occurs within the resizable.
#
# @param {TouchEvent} e - The mouse or touch event.
#
# @this stout-ui/resizable/ResizableView#
# @function onResizeEnd
###
onTouchStart = (e) ->
  onTouchOrMouseMoveInside.call @, e
  onResizeStart.call @, e


###*
# Handles when a resize ends (mouseup/touchend).
#
# @this stout-ui/resizable/ResizableView#
# @function onResizeEnd
###
onResizeEnd = (e) ->
  @classes.remove RESIZING_CLASS
  bmu = @__resizeableListeners.bmu
  bte = @__resizeableListeners.bte
  bml = @__resizeableListeners.bml
  bmm = @__resizeableListeners.bmm
  btm = @__resizeableListeners.btm
  @removeEventListenerFrom(document.body, 'mouseup', bmu)
  @removeEventListenerFrom(document.body, 'touchend', bte)
  @removeEventListenerFrom(document.body, 'mouseleave', bml)
  @removeEventListenerFrom(document.body, 'mousemove', bmm)
  @removeEventListenerFrom(document.body, 'touchmove', btm)
  @__resizeStart = null
  @fire 'resizeend', generateResizeEventData.call @, e


###*
# Handles when a pointing device enters the resizable component.
#
# @this stout-ui/resizable/ResizableView#
# @function onResizableEnter
###
onResizableEnter = ->
  b = document.body
  mm = @addEventListenerTo b, 'mousemove', onTouchOrMouseMoveInside, @
  md = @addEventListener 'mousedown', onResizeStart, @
  @__resizeableListeners.mm = mm
  @__resizeableListeners.mm = md


###*
# Handles when a pointing device leaves the resizable component.
#
# @this stout-ui/resizable/ResizableView#
# @function onResize
###
onResizableLeave = ->
  b = document.body
  @removeEventListenerFrom b, 'mousemove', @__resizeableListeners.mm
  @removeEventListener 'mousedown', @__resizeableListeners.md


###*
# Handles resizing the element.
#
# @param {MouseEvent|TouchEvent} e - The mouse or touch event.
#
# @this stout-ui/resizable/ResizableView#
# @function onResize
###
onResize = (e) ->
  e.stopImmediatePropagation()
  e.stopPropagation()
  e.preventDefault()

  if not @__resizeDir then return

  if @__resizeStart is null
    @__resizeStart = getClientResizeAndSizePosition.call @, e

  data = generateResizeEventData.call @, e

  initialHeight = @__resizeStart[2]
  initialWidth  = @__resizeStart[3]
  initialTop    = @__resizeStart[4]
  initialLeft   = @__resizeStart[5]

  t = initialTop
  l = initialLeft

  # Clamp the delta to min/max height and width.
  #if initialHeight - data.deltaY <= @

  switch @__resizeDir
    when 'n', 'nw', 'ne'
      h = initialHeight - data.deltaY
    when 's', 'sw', 'se'
      h = initialHeight + data.deltaY
    when 'e', 'w'
      h = data.height

  switch @__resizeDir
    when 'n', 's'
      w = data.width
    when 'e', 'ne', 'se'
      w = initialWidth + data.deltaX
    when 'w', 'nw', 'sw'
      w = initialWidth - data.deltaX

  h = clamp(h, @minHeight, @maxHeight)
  w = clamp(w, @minWidth, @maxWidth)


  ut = initialTop + initialHeight - h
  ul = initialLeft + initialWidth - w

  switch @__resizeDir
    when 'n', 'ne'
      t = ut
    when 'w', 'sw'
      l = ul
    when 'nw'
      t = ut
      l = ul

  # Set root styles for resize.
  @root.style.height = "#{h}px"
  @root.style.width = "#{w}px"

  # Adjust width if not reached min/max width.
  @root.style.left = "#{l}px"

  # Adjust height if not reached min/max height.
  @root.style.top = "#{t}px"

  @fire 'resize', generateResizeEventData.call @, e


###*
# Adds resize-appropriate mouse cursors when a mousemove occurs within a
# resizable element. It also determines which direction (N, S, E, W, NW, NE,
# SW, SE) the element is allowed to resize.
#
# @param {MouseEvent|TouchEvent} e - The mouse or touch event.
#
# @this stout-ui/resizable/ResizableView#
# @function onTouchOrMouseMoveInside
###
onTouchOrMouseMoveInside = (e) ->

  # Don't change classes while a resize is in progress.
  if @classes.contains(RESIZING_CLASS) then return

  # Get dimensions and mouse coordinates relative to resizable element.
  {x, y, width, height} = generateResizeEventData.call @, e

  # Grab props to prevent multiple dereferences.
  offset = @resizableOffset
  area = @resizableArea

  # Enlarge the resizable are for touch events.
  if e.touches then area *= 3

  # Check if within the NE or SW corners.
  ne = inRec(x, y, offset, width - offset - area, area, area)
  sw = inRec(x, y, height - offset - area, offset, area, area)
  nesw = ne or sw

  # Check if within the NW or SE corners.
  nw = inRec(x, y, offset, offset, area, area)
  se = inRec(x, y, height - offset - area, width - offset - area, area, area)
  nwse = nw or se

  # Don't check for EW or NS resizing if over a corner.
  if not nesw and not nwse

    # Check if within an x-resizable area.
    w = inRec(x, y, offset, offset, height - 2 * offset, area)
    e = inRec(x, y, offset, width - 2 * offset - area, height - 2 * offset, area)
    ew = e or w

    # Check if within an x-resizable area.
    n = inRec(x, y, offset, offset, area, width - 2 * offset)
    s = inRec(x, y, height - offset - area, offset, area, width - 2 * offset)
    ns = n or s

  # Remove existing classes to reset.
  @classes.remove NS_CURSOR_CLASS
  @classes.remove EW_CURSOR_CLASS
  @classes.remove NESW_CURSOR_CLASS
  @classes.remove NWSE_CURSOR_CLASS

  if ne
    @__resizeDir = 'ne'
  else if sw
    @__resizeDir = 'sw'
  else if nw
    @__resizeDir = 'nw'
  else if se
    @__resizeDir = 'se'
  else if e
    @__resizeDir = 'e'
  else if w
    @__resizeDir = 'w'
  else if n
    @__resizeDir = 'n'
  else if s
    @__resizeDir = 's'
  else
    @__resizeDir = null

  # Disable dragging when inside resizable area.
  if @usingTrait Draggable
    if @__resizeDir
      @draggable = false
    else
      @draggable = true

  # Add appropriate listeners and set cursor classes.
  if nesw
    @classes.add NESW_CURSOR_CLASS
  else if nwse
    @classes.add NWSE_CURSOR_CLASS
  else if ew
    @classes.add EW_CURSOR_CLASS
  else if ns
    @classes.add NS_CURSOR_CLASS


###*
# Generates resize event data.
#
# @param {MouseEvent|TouchEvent} e - The mouse or touch event.
#
# @returns {Object} An object with resize event data. For `resizestart` and
# `resizeend` events it contains `x` and `y` coordinates of the mouse or touch
# relative to the resizable element, and the current `width` and `height` of
# the resizable. For the `resize` event, it also contains `deltaX` and `deltaY`
# which are the total change in element size from the `resizestart` event.
#
# @this stout-ui/resizable/ResizableView#
# @function generateResizeEventData
###
generateResizeEventData = (e) ->
  data = {}
  dim = @root.getBoundingClientRect()

  # Get mouse coordinates relative to the resizable element.
  data.x = e.pageX - dim.left - window.scrollX
  data.y = e.pageY - dim.top - window.scrollY

  # Get the dimensions of the resizable element.
  data.width = dim.width
  data.height = dim.height

  # If currently resizing, add movement data.
  if @classes.contains(RESIZING_CLASS)
    [clientX, clientY] = getClientResizeAndSizePosition.call @, e
    startX = @__resizeStart[0]
    startY = @__resizeStart[1]
    data.deltaX = clientX - startX
    data.deltaY = clientY - startY

  data


###*
# Gets the client mouse or touch coordinates and size/position of resizable
# element.
#
# @param {MouseEvent|TouchEvent} e - The mouse or touch event.
#
# @returns {Array.<number>} An array describing the mouse or touch event
# client location and resizable element size and position, in the form of
# `[clientX, clientY, height, width, top, left]`. The `top` and `left`
# coordinates are relative to the resizable's parent element, and padding
# is accounted for.
#
# @this stout-ui/resizable/ResizableView#
# @function getClientResizeAndSizePosition
###
getClientResizeAndSizePosition = (e) ->
  dim = @root.getBoundingClientRect()
  clientX = e.clientX or (e.touches and e.touches[0].clientX)
  clientY = e.clientY or (e.touches and e.touches[0].clientY)
  cs = getComputedStyle(@parentEl)
  top = @root.offsetTop - parseInt(cs.paddingTop)
  left = @root.offsetLeft - parseInt(cs.paddingLeft)
  [clientX, clientY, dim.height, dim.width, top, left]



###*
# Makes the component using this trait resizable using the mouse or touch.
#
# @exports stout-ui/resizable/ResizableView
# @mixin
###
module.exports = Foundation.extend 'ResizableView',

  properties:

    ###*
    # Constrains resizing to the "x" or "y" axis. If not defined, the component
    # is resizable on both axis.
    #
    # @member {string|undefined} resizableAxis
    # @memberof stout-ui/resizable/ResizableView#
    ###
    resizableAxis:
      values: [undefined, 'x', 'y']
      set: (v) -> if isString(v) then v.toLowerCase() else v

    ###*
    # Width (in pixels) of resizable handle area around edge of element.
    #
    # @member {string|undefined} resizableArea
    # @memberof stout-ui/resizable/ResizableView#
    ###
    resizableArea:
      default: 7
      type: 'number'

    ###*
    # Offset (in pixels) of resizable handle area around edge of element.
    #
    # @member {string|undefined} resizableOffset
    # @memberof stout-ui/resizable/ResizableView#
    ###
    resizableOffset:
      default: 0
      type: 'number'

    ###*
    # The maximum width of the resizable element.
    #
    # @member {number} maxWidth
    # @memberof stout-ui/resizable/ResizableView#
    ###
    maxWidth:
      default: Infinity
      type: 'number'

    ###*
    # The minimum width of the resizable element.
    #
    # @member {number} minWidth
    # @memberof stout-ui/resizable/ResizableView#
    ###
    minWidth:
      default: 0
      type: 'number'

    ###*
    # The maximum height of the resizable element.
    #
    # @member {number} maxHeight
    # @memberof stout-ui/resizable/ResizableView#
    ###
    maxHeight:
      default: Infinity
      type: 'number'

    ###*
    # The minimum height of the resizable element.
    #
    # @member {number} minHeight
    # @memberof stout-ui/resizable/ResizableView#
    ###
    minHeight:
      default: 0
      type: 'number'


  ###*
  # Initiates this trait by adding the necessary event listeners and classes.
  #
  # @method initTrait
  # @memberof stout-ui/resizable/ResizableView#
  # @private
  ###
  initTrait: ->
    @registerEvents 'resize resizestart resizeend'
    @classes.add RESIZABLE_CLASS
    @addEventListener 'mouseenter', onResizableEnter, @
    @addEventListener 'mouseleave', onResizableLeave, @

    # When a touchstart event occurs inside the resizable, test if it is in
    # a position which should trigger a resize. If so, prevent scrolling so
    # the resize can occur.
    @addEventListenerTo document.body, 'touchstart', (e) ->
      if e.target is @root or @root.contains e.target
        onTouchStart.call @, e
        if @__resizeDir then e.preventDefault()
    , @

    @__resizeableListeners = {}
    @__resizeStart = null
