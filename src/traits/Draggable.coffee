###*
# @overview Makes a component draggable.
#
# @module stout-ui/traits/Draggable
###
Foundation = require 'stout-core/base/Foundation'
isString   = require 'lodash/isString'
vars       = require '../vars'

# Require shared variables.
require '../vars/component'
require '../vars/draggable'


###*
# Draggable class added to draggable components.
#
# @type string
# @const
# @private
###
DRAGGABLE_CLASS = vars.readPrefixed 'draggable/draggable-class'


###*
# Class added to element while a drag is in-progress.
#
# @type string
# @const
# @private
###
DRAGGING_CLASS = vars.readPrefixed 'draggable/dragging-class'



###*
# Makes the component using this trait draggable on touch and mouse events.
#
# @exports stout-ui/traits/Draggable
# @mixin
###
module.exports = class Draggable extends Foundation

  ###*
  # Constrains movement to the "x" or "y" axis. If set to `null` movement is
  # not constrained. If set to "x" or "y" movement is constrained to that axis.
  #
  # @member {string|null} axis
  # @memberof stout-ui/traits/Draggable#
  ###
  @property 'axis',
    values: [null, 'x', 'y',]
    set: (v) -> if isString(v) then v.toLowerCase() else v


  ###*
  # Initiates this trait by adding the necessary event listeners and classes.
  #
  # @method initTrait
  # @memberof stout-ui/traits/Draggable#
  # @private
  ###
  initTrait: ->
    @classes.add DRAGGABLE_CLASS
    @addEventListener 'mousedown', @__startDrag, @
    @addEventListener 'touchstart', @__startDrag, @
    @addEventListenerTo document.body, 'mouseup', @__stopDrag, @
    @addEventListenerTo document.body, 'touchend', @__stopDrag, @
    @addEventListenerTo document.body, 'mouseleave', @__stopDrag, @
    @__dragStart = null
    @__dragStartPosition = null
    @__dragTouchListeners = null
    @__dragMouseListeners = null


  ###*
  # Handles positioning the draggable element when a mousemove or touchmove
  # event occurs.
  #
  # @method __onDrag
  # @memberof stout-ui/traits/Draggable#
  # @private
  ###
  __onDrag: (e) ->
    e.stopPropagation()
    e.preventDefault()
    clientX = e.clientX or e.touches[0].clientX
    clientY = e.clientY or e.touches[0].clientY
    if @__dragStart is null
      @__dragStart = [clientX, clientY]
      @__dragStartPosition = [
        parseInt(@root.style.left or 0)
        parseInt(@root.style.top or 0)
      ]
    else
      deltaX = clientX - @__dragStart[0] + @__dragStartPosition[0]
      deltaY = clientY - @__dragStart[1] + @__dragStartPosition[1]
      if @axis isnt "y" then @root.style.left = deltaX + 'px'
      if @axis isnt "x" then @root.style.top = deltaY + 'px'


  ###*
  # Handles the start of a drag.
  #
  # @method __startDrag
  # @memberof stout-ui/traits/Draggable#
  # @private
  ###
  __startDrag: (e) ->
    if @__dragStart is null
      @classes.add DRAGGING_CLASS
      @__dragMouseListeners = @addEventListenerTo(
        document.body, 'mousemove', @__onDrag, @)
      @__dragTouchListeners = @addEventListenerTo(
        document.body, 'touchmove', @__onDrag, @)


  ###*
  # Handles the stop of a drag.
  #
  # @method __stopDrag
  # @memberof stout-ui/traits/Draggable#
  # @private
  ###
  __stopDrag: ->
    @__dragStart = null
    @classes.remove DRAGGING_CLASS
    @removeEventListenerFrom(document.body, 'mousemove', @__dragMouseListeners)
    @removeEventListenerFrom(document.body, 'touchmove', @__dragTouchListeners)
