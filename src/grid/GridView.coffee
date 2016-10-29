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
    #
    ###
    layout:
      default: 'columns'
      values: ['columns', 'rows']

    ###*
    #
    #
    #
    ###
    colWidth:
      default: '20%'
      type: 'number|string'

    ###*
    #
    #
    #
    ###
    rowHeight:
      default: 100
      type: 'number|string'


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
    # Calculates the width of the grid in pixels.
    #
    # @returns {number} Current width of the grid in pixels.
    #
    # @function calcGridWidth
    # @memberof stout-ui/grid/GridView#_addItem
    # @inner
    ###
    calcGridWidth = =>
      @root.getBoundingClientRect().width

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

    itemView.contents = itemView.id # TEMPORARY

    # Create a shadow element indicating where the dragged item will be dropped.
    # (Called with GridItemView as "this")
    shadow = null
    createShadow = ->
      shadow = document.createElement 'div'
      shadow.classList.add @prefix + 'shadow' # TODO: define in constant
      shadow.style.width = @root.style.width
      shadow.style.height = @root.style.height
      shadow.style.top = @root.style.top
      shadow.style.left = @root.style.left
      @parentEl.insertBefore shadow, @root


    positionShadow = (id, row, col, height, width) ->
      if not shadow then return
      [row, col] = @parent._packer.constrain id, row, col
      shadow.style.top = rowSize(row)
      shadow.style.left = colSize(col)
      if height then shadow.style.height = rowSize(height)
      if width then shadow.style.width = colSize(width)


    # (Called with GridItemView as "this")
    deleteShadow = ->
      @parentEl.removeChild(shadow)
      shadow = null


    # (Called with GridView as "this")
    positionItems = (shifted, skip) ->
      @context.items.forEach (item) =>
        if shifted.hasOwnProperty(item.id)
          pos = shifted[item.id]
          item.row = pos.row
          item.column = pos.col

          if item.id not in skip
            item.root.style.top = rowSize(pos.row)
            item.root.style.left = colSize(pos.col)


    # Takes pixel-based x, y, height, width and converts them to grid
    # coordinates.
    convertToGridCoords = (x, y, height, width) ->
      gridWidth = calcGridWidth()
      x = x / gridWidth * 100
      width = width / gridWidth * 100
      top = Math.round(y / parseFloat(rowHeight))
      left = Math.round(x / parseFloat(colWidth))
      height = Math.round(height / parseFloat(rowHeight))
      width = Math.round(width / parseFloat(colWidth))
      {top, left, height, width}


    # (Called with GridItemView as "this")
    onDrag = (e) ->
      {x, y} = e.data
      {top, left} = convertToGridCoords(x, y)
      shifted = @parent._packer.moveTo @id, top, left
      positionShadow.call(@, @id, top, left)
      setGridSize.call @parent
      positionItems.call @parent, shifted, [@id]
      shifted


    onDragStop = (e) ->
      shifted = onDrag.call @, e
      @parent.context.items.forEach (item) ->
        if shifted.hasOwnProperty item.id
          pos = shifted[item.id]
          item.root.style.top = rowSize(pos.row)
          item.root.style.left = colSize(pos.col)


    onResize = (e) ->
      {width, height} = e.data
      left = parseInt(@root.style.left)
      top  = parseInt(@root.style.top)
      {top, left, width, height} = convertToGridCoords(left, top, height, width)
      shifted = @parent._packer.moveTo @id, top, left, height, width
      positionShadow.call(@, @id, top, left, height, width)
      setGridSize.call @parent
      positionItems.call @parent, shifted, [@id]
      shifted


    onResizeEnd = (e) ->
      shifted = onResize.call @, e
      @parent.context.items.forEach (item) ->
        if shifted.hasOwnProperty item.id
          pos = shifted[item.id]
          item.root.style.top = rowSize(pos.row)
          item.root.style.left = colSize(pos.col)
          item.root.style.width = colSize(pos.width)
          item.root.style.height = rowSize(pos.height)

    itemView.on 'drag', throttle(onDrag, 300, trailing: true)
    itemView.on 'resize', throttle(onResize, 100, trailing: false)
    itemView.on 'resizestart dragstart', createShadow
    itemView.on 'dragstop resizeend', deleteShadow
    itemView.on 'dragstop', onDragStop
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
