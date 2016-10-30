###*
# @overview Defines the `GridView` class, the view class for the grid component.
#
# @module stout-ui/grid/GridView
###
assign        = require 'lodash/assign'
debounce      = require 'lodash/debounce'
defaults      = require 'lodash/defaults'
ComponentView = require '../component/ComponentView'
intersection  = require 'lodash/intersection'
keys          = require 'lodash/keys'
Packer        = require '../packer/Packer'
omit          = require 'lodash/omit'
reverse       = require 'lodash/reverse'
throttle      = require 'lodash/throttle'
uniq          = require 'lodash/uniq'
vars          = require '../vars'
without       = require 'lodash/without'

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
#
#
#
###
module.exports = ComponentView.extend 'GridView',

  constructor: (init, events) ->
    init = defaults init, tagName: TAG_NAME
    ComponentView.prototype.constructor.call @, init, events
    @prefixedClasses.add GRID_CLASS

    @context.items.on 'add', (e) => @_addItem e.data

    @context.items.on 'remove', (e) => @_removeItem e.data

    @_packer = new Packer 100, 5


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
      default: '20%'
      type: 'number|string'

    ###*
    # The height of each row of this grid, in pixels.
    #
    # @member {number} rowHeight
    # @memberof stout-ui/grid/GridView#
    ###
    rowHeight:
      default: 100
      type: 'number'

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
    if @colWidth.indexOf and @colWidth.indexOf('%') isnt -1
      x = cols * parseFloat(@colWidth) + '%'
    else
      x = cols * parseFloat(@colWidth) + 'px'
    y = rows * parseFloat(@rowHeight) + 'px'
    [y, x]


  toGridCoords: (x, y) ->
    x = x / @gridWidth * 100
    rows = Math.round(y / parseFloat(@rowHeight))
    cols = Math.round(x / parseFloat(@colWidth))
    [rows, cols]


  ###*
  #
  #
  # @returns {Array.<string|number>} `[top, left, width, height]`
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
    colWidth  = @colWidth
    rowHeight = @rowHeight

    ###*
    # Converts a passed number of columns and converts it to a pixel or
    # percentage width.
    #
    # @param {number} cols - Width in columns.
    #
    # @returns {string} Width in pixels or percentage, suffixed with `'%'` or
    # `'px'`, as appropriate.
    #
    # @function colSize
    # @memberof stout-ui/grid/GridView#_addItem
    # @inner
    ###
    colSize = (cols) =>
      if colWidth.indexOf and colWidth.indexOf('%') isnt -1
        cols * parseFloat(colWidth) + '%'
      else
        cols * parseFloat(colWidth) + 'px'

    ###*
    # Converts a passed number of rows and converts it to a pixel height.
    #
    # @param {number} rows - Height in rows.
    #
    # @returns {string} Height in pixels, suffixed with `'px'`.
    #
    # @function colSize
    # @memberof stout-ui/grid/GridView#_addItem
    # @inner
    ###
    rowSize = (rows) =>
      rows * parseFloat(rowHeight) + 'px'


    ###*
    # Sets the height of the containing grid element to match the contained
    # grid items.
    #
    # @function colSize
    # @memberof stout-ui/grid/GridView#_addItem
    # @inner
    ###
    setGridSize = =>
      @root.style.height = rowSize(@_packer.height())

    {height, width, id} = itemView
    [row, col] = @_packer.insert height, width, id

    itemView.row = row
    itemView.column = col

    itemView.root.style.left = colSize(col)
    itemView.root.style.top = rowSize(row)
    itemView.root.style.height = rowSize(itemView.height)
    itemView.root.style.width = colSize(itemView.width)
    itemView.parent = @
    itemView.parentEl = @root

    positionItems = (shifted, skip = []) ->
      @context.items.forEach (item) =>
        if shifted.hasOwnProperty(item.id)
          pos = shifted[item.id]
          item.row = pos.row
          item.column = pos.col
          if item.id not in skip
            item.root.style.top = rowSize(pos.row)
            item.root.style.left = colSize(pos.col)
            item.root.style.width = colSize(pos.width)
            item.root.style.height = rowSize(pos.height)

    onDrag = (e) ->
      {x, y} = e.data
      [row, col] = @parent.toGridCoords(x, y)
      shifted = @parent._packer.moveTo @id, row, col
      setGridSize.call @parent
      positionItems.call @parent, shifted, [@id]
      shifted

    onResize = (e) ->
      {width, height} = e.data
      top  = parseInt(@root.style.top)
      left = parseInt(@root.style.left)

      [row, col] = @parent.toGridCoords(left, top)
      [height, width] = @parent.toGridCoords(width, height)

      shifted = @parent._packer.moveTo @id, row, col, height, width
      setGridSize.call @parent
      positionItems.call @parent, shifted, [@id]
      shifted

    onResizeEnd = (e) ->
      shifted = onResize.call @, e
      positionItems.call @parent, shifted

    itemView.on 'drag', throttle(onDrag, 300, {trailing: true, leading: false})
    itemView.on 'resize', throttle(onResize, 100, {trailing: true, leading: false})
    itemView.on 'resizeend', onResizeEnd

    itemView.render()
    setGridSize()


  ###*
  # Removes an item from the grid.
  #
  # @param {stout-ui/grid/GridItemView} itemView - The `GridItemView` to remove.
  ###
  _removeItem: (itemView) ->
    @_packer.remove itemView.id
    itemView.unrender()
