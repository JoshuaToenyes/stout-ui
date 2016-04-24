###*
# @overview Defines the `TreeItemView` view class, the view portion of a Table of
# Contents item component.
#
# @module stout-ui/tree/TreeItemView
###
defaults        = require 'lodash/defaults'
InteractiveView = require '../interactive/InteractiveView'
Promise         = require 'stout-core/promise/Promise'
template        = require './tree-item.template'
vars            = require '../vars'

# Require shared input variables.
require '../vars/tree'


###*
# The table-of-contents custom tag name.
#
# @type string
# @const
# @private
###
TAG_NAME = vars.readPrefixed 'tree/tree-item-tag'


###*
# The tree custom tag name.
#
# @type string
# @const
# @private
###
TREE_TAG_NAME = vars.readPrefixed 'tree/tree-tag'


###*
# The tree-item class name.
#
# @type string
# @const
# @private
###
TREE_ITEM_CLS = vars.read 'tree/tree-item-class'


###*
# Collapsible class added to items which should be rendered as "collapsible."
#
# @type {string}
# @const
###
COL_CLS = vars.read 'tree/tree-collapsible-class'


###*
# Class indicating that the item is currently collapsed.
#
# @type {string}
# @const
###
COLLAPSED_CLS = vars.read 'tree/tree-collapsed-class'



###*
# The `TreeItemView` class represents the view part of a table of contents
# item component.
#
# @exports stout-ui/tree/TreeItemView
# @extends stout-ui/interactive/InteractiveView
# @constructor
###
module.exports = class TreeItemView extends InteractiveView

  constructor: (init, events) ->
    defaults init, {template, tagName: TAG_NAME}
    super init, events

    @prefixedClasses.add TREE_ITEM_CLS

    @root.setAttribute 'role', 'listitem'

    @on 'ready', @_updateCollapsible, @

    @on 'tap', (e) =>
      e.data.stopPropagation()
      @toggle()


  ###*
  # Property indicating if this item's children can be collapsed. This property
  # has no meaning if this item has no children.
  #
  # @member {boolean} collapsible
  # @memberof stout-ui/tree/TreeItemView#
  ###
  @property 'collapsible',
    type: 'boolean'
    default: true


  ###*
  # The current collapsed state of this tree item. This property has no meaning
  # if it has no children.
  #
  # @member {boolean} collapsible
  # @memberof stout-ui/tree/TreeItemView#
  ###
  @property 'collapsed',
    type: 'boolean'
    default: true


  ###*
  # Opens the child tree of this tree item, if it is currently collapsed and
  # is collapsible.
  #
  # @method open
  # @memberof stout-ui/tree/TreeItemView#
  ###
  open: ->
    if @collapsible and @collapsed
      @prefixedClasses.remove COLLAPSED_CLS
      @collapsed = false
      @_updateHeight()


  ###*
  # Closes the child tree of this tree item, if it is currently open and
  # is collapsible.
  #
  # @method close
  # @memberof stout-ui/tree/TreeItemView#
  ###
  close: ->
    @collapsed = true
    @_updateHeight(true)
    setTimeout =>
      @prefixedClasses.add COLLAPSED_CLS
    , 500


  ###*
  # Toggles the open/closed state of this tree view item.
  #
  # @method toggle
  # @memberof stout-ui/tree/TreeItemView#
  ###
  toggle: ->
    if @collapsed then @open() else @close()


  ###*
  # Calculates and returns (as a promise) the height of this tree including
  # any subtrees.
  #
  # @returns {module:stout-core/promise/Promise} Promise resolved to the height
  # of the tree in pixels.
  ###
  _getHeight: ->
    promises = []

    @children.get(TREE_TAG_NAME).every (tree) ->
      promises.push tree.getRenderedDimensions(null, ['height'])

      tree.children.get(TAG_NAME).every (item) ->
        promises.push item._getHeight()

    Promise.all(promises).then (a) ->
      if not a or a.length is 0
        0
      else
        a.reduce ((p, v) -> p + (+v?.height or 0)), 0


  ###*
  # Updates the height of this tree item, then travels up the tree and adjusts
  # the height of all parents trees.
  #
  # @param {boolean} close - Set to `true` if closing the tree.
  #
  # @method _updateCollapsible
  # @memberof stout-ui/tree/TreeItemView#
  # @private
  ###
  _updateHeight: (close) ->
    @_getHeight().then (r) =>
      tree = @children.get(TREE_TAG_NAME)[0]

      m = if close then -1 else 1

      if not @collapsed
        tree.root.style.height = r + 'px'
      else
        tree.root.style.height = '0'

      closeUpTree = (tree) ->
        if not tree then return
        if tree.parent and tree.parent.collapsible
          tree.getRenderedDimensions().then (d) =>
            tree.root.style.height = d.height + m * r + 'px'
            closeUpTree tree.parent.parent

      closeUpTree @parent


  ###*
  # Updates the "collapsible" display state of this item.
  #
  # @method _updateCollapsible
  # @memberof stout-ui/tree/TreeItemView#
  # @private
  ###
  _updateCollapsible: ->

    # Update collapsed and collapsable classes based on child trees.
    @prefixedClasses.remove COL_CLS, COLLAPSED_CLS

    if @children.get(TREE_TAG_NAME).length > 0 and @collapsible
      @_updateHeight(@collapsed)
      @prefixedClasses.add COL_CLS

    if @collapsed and @collapsible
      @prefixedClasses.add COLLAPSED_CLS
