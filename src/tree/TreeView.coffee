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


###*
# The time (in millseconds) a collapse operation should take.
#
# @type {number}
# @const
###
COLLAPSE_T = vars.readTime 'tree/tree-collapse-time'


###*
# The time (in millseconds) an expand operation should take.
#
# @type {number}
# @const
###
EXPAND_T = vars.readTime 'tree/tree-expand-time'


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


  ###*
  # Height-setting timer.
  #
  # @member _heightSettingTimer
  # @memberof stout-ui/tree/TreeView
  # @private
  ###


  collapse: ->
    i = 0
    promises = []

    @getRenderedDimensions(null, ['height']).then (d) =>

      @root.style.height = d.height + 'px'
      @repaint()

      # Transition out all children items in a ripple-like fashion.
      @children.get(ITEM_TAG_NAME).reverse().every (item) ->
        delay = ++i * ITEM_OFFSET_T
        promises.push item.transitionOut(ITEM_TRANS_OUT_T, delay)

      # Transition out this tree.
      promises.push @transitionOut(COLLAPSE_T, ITEM_TRANS_OUT_T)

      clearTimeout @_heightSettingTimer
      @_heightSettingTimer = setTimeout =>
        @root.style.height = '0'
      , ITEM_TRANS_OUT_T

      # Return a promise that resolves when the tree and all its children are
      # collapsed and its height is set to zero.
      Promise.all(promises)


  ###*
  #
  #
  ###
  expand: ->
    # Clear existing collapsing timer.
    clearTimeout @_heightSettingTimer

    # Calculate the rendered height of this tree.
    @getRenderedDimensions(null, ['height']).then (d) =>
      i = 0
      promises = []

      @once 'transition:in', =>
        @root.style.height = d.height + 'px'

      # Transition-in all children.
      @children.get(ITEM_TAG_NAME).every (item) ->
        delay = ++i * ITEM_OFFSET_T + ITEM_TRANS_IN_T / 2
        promises.push item.transitionIn(ITEM_TRANS_IN_T, delay)

      promises.push @transitionIn(EXPAND_T)

      Promise.all(promises).then =>
        @root.style.height = 'auto'



  toggle: ->
