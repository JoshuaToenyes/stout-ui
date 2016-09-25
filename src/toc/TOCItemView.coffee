###*
# @overview Defines the `TOCItemView` view class, the view portion of a Table of
# Contents item component.
#
# @module stout-ui/toc/TOCItemView
###
defaults     = require 'lodash/defaults'
TreeItemView = require '../tree/TreeItemView'
template     = require './toc.template'
vars         = require '../vars'

# Require shared input variables.
require '../vars/toc'


###*
# The table-of-contents custom tag name.
#
# @type string
# @const
# @private
###
TAG_NAME = vars.readPrefixed 'toc/toc-item-tag'


###*
# The table-of-contents item class name.
#
# @type string
# @const
# @private
###
TOC_ITEM_CLS = vars.read 'toc/toc-item-class'


###*
# The `TOCItemView` class represents the view part of a table of contents
# item component.
#
# @exports stout-ui/toc/TOCItemView
# @extends stout-ui/interactive/InteractiveView
# @constructor
###
module.exports = class TOCItemView extends TreeItemView

  constructor: (init, events) ->
    defaults init, {tagName: TAG_NAME}
    super init, events

    @prefixedClasses.add TOC_ITEM_CLS
