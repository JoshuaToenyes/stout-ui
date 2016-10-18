###*
# @overview
#
# @module stout-ui/grid
###
defaults     = require 'lodash/defaults'
Grid         = require './Grid'
GridView     = require './GridView'
GridItem     = require './GridItem'
GridItemView = require './GridItemView'
parser       = require 'stout-client/parser'

# Read the button custom HTML tag.
GRID_TAG_NAME = vars.readPrefixed 'grid/grid-tag'

# Read the button custom HTML tag.
GRID_ITEM_TAG_NAME = vars.readPrefixed 'grid/grid-item-tag'

# Register the tags.
parser.register GRID_TAG_NAME, GridView, Grid
parser.register GRID_ITEM_TAG_NAME, GridItemView, GridItem



module.exports =

  ###*
  # Create a new Grid component.
  #
  #
  ###
  create: (init) ->
    init = defaults init, {context: new Grid}
    view = new GridView init
    view.context


  createItem: (init) ->
    init = defaults init, {context: new GridItem}
    view = new GridItemView init
    view.context
