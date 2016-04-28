###*
# @overview Defines the `TreeView` view class, the view portion of a Table of
# Contents component.
#
# @module stout-ui/tree/TreeView
###
defaults        = require 'lodash/defaults'
InteractiveView = require '../interactive/InteractiveView'
Promise         = require 'stout-core/promise/Promise'
template        = require './tree.template'
vars            = require '../vars'

# Require shared input variables.
require '../vars/tree'


###*
# The tree custom tag name.
#
# @type string
# @const
# @private
###
TAG_NAME = vars.readPrefixed 'tree/tree-tag'


###*
# The tree class name.
#
# @type string
# @const
# @private
###
TREE_CLS = vars.read 'tree/tree-class'


###*
# Custom tree-item tag name.
#
# @type string
# @const
# @private
###
ITEM_TAG_NAME = vars.readPrefixed 'tree/tree-item-tag'


ITEM_TRANS_IN_T = vars.readTime 'tree/tree-item-trans-in-time'
ITEM_TRANS_OUT_T = vars.readTime 'tree/tree-item-trans-out-time'
ITEM_OFFSET_T = vars.readTime 'tree/tree-item-offset-time'
TREE_TRANS_T = vars.readTime 'tree/tree-item-collapse-time'


###*
# The `TreeView` class represents the view part of a Table of Contents component.
#
# @exports stout-ui/tree/TreeView
# @extends stout-ui/interactive/InteractiveView
# @constructor
###
module.exports = class TreeView extends InteractiveView

  constructor: (init, events) ->
    defaults init, {template, tagName: TAG_NAME}
    super init, events

    @prefixedClasses.add TREE_CLS

    @root.setAttribute 'role', 'list'


  collapse: ->
    i = 0
    promises = []
    @children.get(ITEM_TAG_NAME).reverse().every (item) ->
      promises.push item.transitionOut(ITEM_TRANS_OUT_T, ++i * ITEM_OFFSET_T)
      promises.push item.collapse()
    Promise.all(promises).then => @setHeight 0


  expand: ->
    @getRenderedDimensions(null, ['height']).then (d) =>
      i = 0
      promises = []
      @setHeight(d.height)
      @children.get(ITEM_TAG_NAME).every (item) ->
        delay = ++i * ITEM_OFFSET_T + TREE_TRANS_T / 2
        promises.push item.transitionIn(ITEM_TRANS_IN_T, delay)
      Promise.all promises


  setHeight: (h) ->
    @root.style.height = h + 'px'



  increaseHeight: (h) ->
    ch = parseInt(@root.style.height)
    @setHeight(ch + h)


  reduceHeight: (h) ->
    ch = parseInt(@root.style.height)
    @setHeight(ch - h)


  updateHeight: (h) ->
    ch = parseInt(@root.style.height)
    @setHeight(ch + h)


  toggle: ->


  render: ->
    super().then =>
      @getRenderedDimensions().then (d) =>
        @setHeight(d.height)
