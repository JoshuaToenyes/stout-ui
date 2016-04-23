###*
# @overview Defines the `TreeView` view class, the view portion of a Table of
# Contents component.
#
# @module stout-ui/tree/TreeView
###
defaults        = require 'lodash/defaults'
InteractiveView = require '../interactive/InteractiveView'
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
