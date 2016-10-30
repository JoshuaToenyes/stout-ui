Component    = require '../component/Component'
defaults     = require 'lodash/defaults'
GridItem     = require './GridItem'
GridItemView = require './GridItemView'
OrderedList  = require 'stout-core/collection/OrderedList'


module.exports = Component.extend 'Grid',

  properties:

    ###*
    # Set of items within the grid.
    #
    # @member {stout-core/collection/OrderedList} items
    # @memberof stout-ui/gird/Grid
    ###
    items:
      default: -> new OrderedList


  ###*
  # Creates a new grid item and adds it to the grid.
  #
  # @param {Object} init - Initiation params for the `GridItemVies` instance.
  #
  # @returns {stout-ui/grid/GridItemView} The newly created `GridItemView`
  # instance.
  #
  # @method createItem
  # @memberof stout-ui/grid/Grid
  ###
  createItem: (init) ->
    init = defaults init, {context: new GridItem}
    gridItem = new GridItemView init
    @items.add gridItem
    gridItem


  ###*
  # Destroys all grid items.
  #
  # @method destroyGridItems
  # @memberof stout-ui/grid/Grid
  ###
  destroyGridItems: ->
    @items.forEach (item) ->
      item.destroy()
    @items.clear()
