###*
# @overview Defines the `GridItemView` class, the view class for a grid item
# component.
#
# @module stout-ui/grid/GridItemView
###
defaults        = require 'lodash/defaults'
Draggable       = require '../traits/Draggable'
InteractiveView = require '../interactive/InteractiveView'
ResizableView   = require '../resizable/ResizableView'
uuid            = require 'uuid'
vars            = require '../vars'

# Require grid shared variables.
require '../vars/grid'


###*
# The grid custom tag name.
#
# @type string
# @const
# @private
###
TAG_NAME = vars.readPrefixed 'grid/grid-item-tag'


###*
# The grid item class name.
#
# @type string
# @const
# @private
###
GRID_ITEM_CLASS = vars.read 'grid/grid-item-class'


###*
# Handles a drag end event. Removes shadow and positions the grid item view,
# snapped to the grid.
#
# @param {stout-core/events/Event} e - Drag end event.
#
# @function onItemViewDragEnd
# @this stout-ui/grid/GridItemView#
###
onItemViewDragEnd = ->
  removeShadow.call @
  [top, left] = @parent.fromGridCoords(@row, @column)
  @root.style.top = top
  @root.style.left = left


###*
# Handles a drag event.
#
# @param {stout-core/events/Event} e - Drag event.
#
# @function onItemViewDrag
# @this stout-ui/grid/GridItemView#
###
onItemViewDrag = (e) ->
  [top, left] = @parent.snapToGrid(e.data.x, e.data.y)
  positionShadow.call @, {top, left}


###*
# Handles a resize event.
#
# @param {stout-core/events/Event} e - Drag event.
#
# @function onItemViewResize
# @this stout-ui/grid/GridItemView#
###
onItemViewResize = (e) ->
  left = parseInt(@root.style.left)
  top  = parseInt(@root.style.top)
  width = e.data.width
  height = e.data.height
  [top, left, height, width] = @parent.snapToGrid(left, top, width, height)
  positionShadow.call @, {top, left, height, width}


###*
# Creates a drag/resize shadow for this item.
#
# @function createShadow
# @this stout-ui/grid/GridItemView#
###
createShadow = ->
  @__shadow = document.createElement 'div'
  @__shadow.classList.add @prefix + 'shadow' # TODO: define in constant
  positionShadow.call @, @root.style
  @parentEl.insertBefore @__shadow, @root


###*
# Removes the drag/resize shadow for this item.
#
# @function removeShadow
# @this stout-ui/grid/GridItemView#
###
removeShadow = ->
  @parentEl.removeChild @__shadow
  @__shadow = null


###*
# Handles a resize end event.
#
# @function onItemViewResizeEnd
# @this stout-ui/grid/GridItemView#
###
onItemViewResizeEnd = ->
  removeShadow.call @


###*
# Positions the drag/resize shadow for this item.
#
# @param {Object} desc - An object describing the size and position of the
# shadow. May contain `height`, `width`, `top`, or `left`. Keys present will
# be set on the shadow node.
#
# @function positionShadow
# @this stout-ui/grid/GridItemView#
###
positionShadow = (desc) ->
  if @__shadow is null then return
  for p in ['width', 'height', 'top', 'left']
    if desc[p] then @__shadow.style[p] = desc[p]



###*
# The `GridItemView` class is a single item within a grid.
#
# @exports stout-ui/grid/GridItemView
# @extends stout-ui/interactive/InteractiveView
# @constructor
###
module.exports = InteractiveView.extend 'GridItemView',

  traits: [Draggable, ResizableView]

  constructor: (init, events) ->
    init = defaults init,
      tagName: TAG_NAME
      resizeContain: ['n', 'w', 'e']
      dragContain: ['n', 'w', 'e']
    InteractiveView.prototype.constructor.call @, init, events
    @prefixedClasses.add GRID_ITEM_CLASS
    @__shadow = null
    @on 'dragstart resizestart', createShadow, @
    @on 'resizeend', onItemViewResizeEnd, @
    @on 'dragstop', onItemViewDragEnd, @
    @on 'resize', onItemViewResize, @
    @on 'drag', onItemViewDrag, @


  properties:

    ###*
    # The ID of this grid item view. Used for grid positioning.
    #
    # @member {string} id
    # @memberof stout-ui/grid/GridItemView#
    ###
    id:
      default: -> uuid.v4()

    ###*
    # The height of this grid item in rows.
    #
    # @member {number} height
    # @memberof stout-ui/grid/GridItemView#
    ###
    height:
      default: 1
      type: 'number'

    ###*
    # The width of this grid item in columns.
    #
    # @member {number} width
    # @memberof stout-ui/grid/GridItemView#
    ###
    width:
      default: 1
      type: 'number'

    ###*
    # The row position of this grid item.
    #
    # @member {number} row
    # @memberof stout-ui/grid/GridItemView#
    ###
    row:
      type: 'undefined|number'

    ###*
    # The column position of this grid item.
    #
    # @member {number} column
    # @memberof stout-ui/grid/GridItemView#
    ###
    column:
      type: 'undefined|number'


  remove: ->
    @parent.context.items.remove(@)
