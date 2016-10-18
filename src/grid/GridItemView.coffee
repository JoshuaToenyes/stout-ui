###*
# @overview Defines the `GridItemView` class, the view class for a grid item
# component.
#
# @module stout-ui/grid/GridItemView
###
defaults      = require 'lodash/defaults'
Draggable       = require '../traits/Draggable'
InteractiveView = require '../interactive/InteractiveView'
uuid          = require 'uuid'
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
#
#
#
###
module.exports = InteractiveView.extend 'GridItemView',

  traits: Draggable

  constructor: (init, events) ->
    init = defaults init, tagName: TAG_NAME
    InteractiveView.prototype.constructor.call @, init, events
    @prefixedClasses.add GRID_ITEM_CLASS

  properties:

    id:
      default: -> uuid.v4()

    height:
      default: 1
      type: 'number'

    width:
      default: 1
      type: 'number'

    row:
      type: 'undefined|number'

    column:
      type: 'undefined|number'
