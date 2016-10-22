###*
# @overview Defines the `GridView` class, the view class for the grid component.
#
# @module stout-ui/grid/GridView
###
debounce      = require 'lodash/debounce'
defaults      = require 'lodash/defaults'
ComponentView = require '../component/ComponentView'
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

    @_packer = new Packer 100, 20


  properties:

    layout:
      default: 'columns'
      values: ['columns', 'rows']

    size:
      default: '10%'
      type: 'number|string'



  ###*
  #
  #
  #
  ###
  _addItem: (itemView) ->
    SIZE = 50
    {height, width, id} = itemView
    [row, col] = @_packer.insert height, width, id

    itemView.row = row
    itemView.column = col

    top = (row * SIZE)
    left = (col * SIZE)
    itemView.root.style.left = "#{left}px"
    itemView.root.style.top = "#{top}px"
    itemView.root.style.height = "#{itemView.height * SIZE}px"
    itemView.root.style.width = "#{itemView.width * SIZE}px"
    itemView.parent = @
    itemView.parentEl = @root

    itemView.contents = itemView.id

    # set draggable axis -- TMP
    # itemView.axis = 'x'

    setGridSize = =>
      ch = @_packer.height @_packer
      cw = @_packer.width @_packer
      @root.style.width = "#{cw * SIZE}px"
      @root.style.height = "#{ch * SIZE}px"




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

    positionShadow = (id, row, col) ->
      [row, col] = @parent._packer.constrain id, row, col
      shadow.style.top = "#{row * SIZE}px"
      shadow.style.left = "#{col * SIZE}px"

    # (Called with GridItemView as "this")
    deleteShadow = ->
      @parentEl.removeChild(shadow)
      shadow = null

    # (Called with GridItemView as "this")
    onDrag = (e) ->
      {x, y} = e.data
      leftGridPos = Math.round(x / SIZE)
      topGridPos = Math.round(y / SIZE)
      shifted = @parent._packer.moveTo @id, topGridPos, leftGridPos
      positionShadow.call(@, @id, topGridPos, leftGridPos)
      setGridSize.call @parent

      @parent.context.items.forEach (item) =>
        if item.id is @id then return
        if shifted.hasOwnProperty item.id
          pos = shifted[item.id]
          item.root.style.top = "#{pos.row * SIZE}px"
          item.root.style.left = "#{pos.col * SIZE}px"

      shifted

    itemView.on 'drag', throttle(onDrag, 100, trailing: false)

    itemView.on 'dragstart', createShadow

    itemView.on 'dragstop', (e) ->
      shifted = onDrag.call @, e
      deleteShadow.call @
      @parent.context.items.forEach (item) ->
        if shifted.hasOwnProperty item.id
          pos = shifted[item.id]
          item.root.style.top = "#{pos.row * SIZE}px"
          item.root.style.left = "#{pos.col * SIZE}px"





    itemView.click = =>
      #id = packer.at @_packer, row, col
      #console.log packer.itemsBelow @_packer, id
      # shifted = packer.growDown @_packer, id
      #
      # itemView.height += 1
      # itemView.root.style.height = "#{itemView.height * SIZE}px"
      #
      # @context.items.forEach (item) ->
      #   if shifted.hasOwnProperty item.id
      #     pos = shifted[item.id]
      #     item.root.style.top = "#{pos.row * SIZE}px"

      # shifted = packer.growRight @_packer, id
      #
      # itemView.width += 1
      # itemView.root.style.width = "#{itemView.width * SIZE}px"
      #
      # @context.items.forEach (item) ->
      #   if shifted.hasOwnProperty item.id
      #     pos = shifted[item.id]
      #     item.root.style.top = "#{pos.row * SIZE}px"
      #     item.root.style.left = "#{pos.col * SIZE}px"
      #
      # setGridSize()

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
