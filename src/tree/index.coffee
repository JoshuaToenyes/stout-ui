###*
# @overview Registers the custom tree tags.
#
# @module stout-ui/tree
###
defaults     = require 'lodash/defaults'
Tree         = require './Tree'
TreeItem     = require './TreeItem'
TreeItemView = require './TreeItemView'
TreeView     = require './TreeView'
parser       = require 'stout-client/parser'

# Read the custom HTML tag.
TREE_TAG_NAME = vars.readPrefixed 'tree/tree-tag'
TREE_ITEM_TAG_NAME = vars.readPrefixed 'tree/tree-item-tag'

# Register the custom tag.
parser.register TREE_TAG_NAME, TreeView, Tree
parser.register TREE_ITEM_TAG_NAME, TreeItemView, TreeItem

module.exports = (init) ->

  factory: (init) ->
    defaults init, {context: new Tree}
    (new TreeView init).context

  itemFactory: (init) ->
    defaults init, {context: new TreeItem}
    (new TreeItemView init).context
