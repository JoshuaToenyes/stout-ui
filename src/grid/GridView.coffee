###*
# @overview Defines the `GridView` class, the view class for the grid component.
#
# @module stout-ui/grid/GridView
###
defaults      = require 'lodash/defaults'
ComponentView = require '../component/ComponentView'
isUndefined   = require 'lodash/isUndefined'
Packer        = require '../packer/Packer'
throttle      = require 'lodash/throttle'
vars          = require '../vars'

# Require grid shared variables.
require '../vars/grid'


###*
# The grid custom tag name.
#
# @type string
# @const
# @private
###
TAG_NAME = vars.readPrefixed 'grid/grid-tag'


###*
# The grid class name.
#
# @type string
# @const
# @private
###
GRID_CLASS = vars.read 'grid/grid-class'


###*
# Positions shifted grid items in the browser to match the position indicated
# by the packer instance.
#
# @param {Object} shifted - Shifted items.
#
# @param {Array.<string>} skip - List of IDs to skip positioning.
#
# @function positionItems
# @this stout-ui/grid/GridView#
###
positionItems = (shifted, skip = []) ->
  @context.items.forEach (item) =>
    if shifted.hasOwnProperty(item.id)
      pos = shifted[item.id]
      item.row = pos.row
      item.column = pos.col
      item.height = pos.height
      item.width = pos.width
      if item.id not in skip
        [top, left] = @fromGridCoords pos.row, pos.col
        [height, width] = @fromGridCoords pos.height, pos.width
        item.root.style.top = top
        item.root.style.left = left
        item.root.style.width = width
        item.root.style.height = height


###*
# Sets the height of the containing grid element to match the contained
# grid items.
#
# @function setGridSize
# @this stout-ui/grid/GridItemView#
###
setGridSize = ->
  [height] = @fromGridCoords @_packer.height()
  @root.style.height = height


###*
# Handles a drag event of a GridItemView.
#
# @param {stout-core/event/Event} e - Drag event.
#
# @function onDrag
# @this stout-ui/grid/GridItemView#
###
onDrag = (e) ->
  {x, y} = e.data
  [row, col] = @parent.toGridCoords(x, y)
  shifted = @parent._packer.moveTo @id, row, col
  setGridSize.call @parent
  positionItems.call @parent, shifted, [@id]
  shifted


###*
# Handles the drag-end event of a GridItemView.
#
# @function onDragEnd
# @this stout-ui/grid/GridItemView#
###
onDragEnd = (e) ->
  shifted = onDrag.call @, e
  positionItems.call @parent, shifted


###*
# Handles a resize event of a GridItemView.
#
# @param {stout-core/event/Event} e - Resize event.
#
# @function onResize
# @this stout-ui/grid/GridItemView#
###
onResize = (e) ->
  {width, height} = e.data
  top  = convertToPixels(@root.style.top, @parent.gridWidth)
  left = convertToPixels(@root.style.left, @parent.gridWidth)

  [row, col] = @parent.toGridCoords(left, top)
  [height, width] = @parent.toGridCoords(width, height)

  shifted = @parent._packer.moveTo @id, row, col, height, width
  setGridSize.call @parent
  positionItems.call @parent, shifted, [@id]
  shifted


###*
# Handles the resize-end event of a GridItemView.
#
# @function onResizeEnd
# @this stout-ui/grid/GridItemView#
###
onResizeEnd = (e) ->
  shifted = onResize.call @, e
  positionItems.call @parent, shifted


###*
# Tests if the passed value is a percentage.
#
# @param {string|number} n - The value to test.
#
# @returns {boolean} `true` if a percentage, otherwise `false`.
#
# @function isPercentage
###
isPercentage = (n) ->
  n.indexOf and n.indexOf('%') isnt -1


###*
# Converts the passed `v` param to pixels, if it is a percentage.
#
# @param {string|number} v - The value to convert to pixels.
#
# @param {number} max - The container size, or maximum value of-which the
# percentage is a portion of.
#
# @returns {number} Pixel dimension.
#
# @function convertToPixels
###
convertToPixels = (v, max) ->
  if isPercentage(v)
    max * (parseFloat(v) / 100)
  else
    parseFloat(v)


###*
# The `GridView` class arranges items in a grid in the view.
#
# @exports stout-ui/grid/GridView
# @extends stout-ui/component/ComponentView
# @constructor
###
module.exports = ComponentView.extend 'GridView',

  constructor: (init, events) ->
    init = defaults init, tagName: TAG_NAME
    ComponentView.prototype.constructor.call @, init, events
    @prefixedClasses.add GRID_CLASS

    @context.items.on 'add', (e) => @_addItem e.data

    @context.items.on 'remove', (e) => @_removeItem e.data

    if isPercentage(@colWidth)
      cols = 100 / parseFloat(@colWidth)
    else
      cols = @columnCount

    @_packer = new Packer 100, cols


  properties:

    ###*
    #
    #
    # @todo Not yet implemented.
    ###
    layout:
      default: 'columns'
      values: ['columns', 'rows']

    ###*
    # The width of each column of this grid. May be a number of pixels, or a
    # string percentage.
    #
    # @member {number|string} colWidth
    # @memberof stout-ui/grid/GridView#
    ###
    colWidth:
      default: '6.25%'
      type: 'number|string'

    ###*
    # The number of columns, if using a fixed-width (pixel-based) colWidth.
    #
    # @member {number|string} columnCount
    # @memberof stout-ui/grid/GridView#
    ###
    columnCount:
      type: 'number|undefined'

    ###*
    # The height of each row of this grid, in pixels.
    #
    # @member {number} rowHeight
    # @memberof stout-ui/grid/GridView#
    ###
    rowHeight:
      default: 100
      type: 'number'

    ###*
    # The grid width in pixels.
    #
    # @member {number} rowHeight
    # @memberof stout-ui/grid/GridView#
    # @readonly
    ###
    gridWidth:
      get: ->
        @root.getBoundingClientRect().width
      readonly: true


  ###*
  # Maps row and column coordinates to pixel or percentage size/dimension.
  #
  # @param {number} rows - Rows to map from.
  #
  # @param {number} cols - Cols to map from.
  #
  # @returns {Array.<string|number>} Size/dimension in the from `[y, x]`, (or
  # equivalently, `[top, left]` or `[height, width]`), suffixed with `'px'` or
  # `'%'` as appropriate.
  ###
  fromGridCoords: (rows, cols) ->
    if isPercentage(@colWidth)
      x = cols * parseFloat(@colWidth) + '%'
    else
      x = cols * parseFloat(@colWidth) + 'px'
    y = rows * parseFloat(@rowHeight) + 'px'
    [y, x]


  ###*
  # Converts passed `x` and `y` sizes (or positions) in pixels to grid
  # coordinates (i.e., row and column).
  #
  # @param {number} x - The x-direction size in pixels.
  #
  # @param {number} y - The y-direction size in pixels.
  #
  # @method toGridCoords
  # @memberof stout-ui/grid/GridView#
  ###
  toGridCoords: (x, y) ->
    x = x / @gridWidth * 100
    rows = Math.round(y / parseFloat(@rowHeight))
    cols = Math.round(x / parseFloat(@colWidth))
    [rows, cols]


  ###*
  # Snaps the passed position and dimension to grid coordinates.
  #
  # @param {number} x - Horizontal axis size in pixels.
  #
  # @param {number} y - Vertical axis size in pixels.
  #
  # @param {number} width - Width in pixels.
  #
  # @param {number} height - Height in pixels.
  #
  # @returns {Array.<string|number>} `[top, left, width, height]`
  #
  # @method snapToGrid
  # @memberof stout-ui/grid/GridView#
  ###
  snapToGrid: (x, y, width, height) ->
    [row, col] = @toGridCoords(x, y)
    ret = @fromGridCoords(row, col)
    if width and height
      [row, col] = @toGridCoords(width, height)
      ret = ret.concat @fromGridCoords(row, col)
    ret


  ###*
  # Adds an item to the grid view.
  #
  # @param {stout-ui/grid/GridItemView} itemView - The grid item to add.
  #
  # @method _addItem
  # @memberof stout-ui/grid/GridView
  # @protected
  ###
  _addItem: (itemView) ->
    {height, width, id} = itemView

    if isUndefined(itemView.row) or isUndefined(itemView.column)
      [row, col] = @_packer.insert height, width, id
      itemView.row = row
      itemView.column = col
    else
      {row, column} = itemView
      col = column
      @_packer.insertAt height, width, row, column, id

    [top, left] = @fromGridCoords row, col
    [height, width] = @fromGridCoords height, width

    for prop, v of {top, left, height, width}
      itemView.root.style[prop] = v

    itemView.resizeContainer = @root
    itemView.dragContainer = @root
    itemView.parent = @
    itemView.parentEl = @root

    throttleOptions = {trailing: true, leading: false}
    itemView.on 'drag', throttle(onDrag, 300, throttleOptions)
    itemView.on 'resize', throttle(onResize, 100, throttleOptions)
    itemView.on 'dragstop', onDragEnd
    itemView.on 'resizeend', onResizeEnd

    itemView.render()
    setGridSize.call @


  ###*
  # Removes an item from the grid.
  #
  # @param {stout-ui/grid/GridItemView} itemView - The `GridItemView` to remove.
  #
  # @method _removeItem
  # @memberof stout-ui/grid/GridView#
  # @protected
  ###
  _removeItem: (itemView) ->
    @_packer.remove itemView.id
    if itemView.rendered then itemView.unrender()
    setGridSize.call @
