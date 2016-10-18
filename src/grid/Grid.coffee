Component    = require '../component/Component'
defaults     = require 'lodash/defaults'
GridItem     = require './GridItem'
GridItemView = require './GridItemView'
OrderedList  = require 'stout-core/collection/OrderedList'


module.exports = Component.extend 'Grid',

  properties:

    ###*
    #
    #
    #
    ###
    items:
      default: -> new OrderedList


  createItem: (init) ->
    init = defaults init, {context: new GridItem}
    gridItem = new GridItemView init

    gridItem.remove = => @items.remove(gridItem)

    #gridItem.click = -> @remove()

    @items.add gridItem
    gridItem
