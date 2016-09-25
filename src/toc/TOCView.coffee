###*
# @overview Defines the `TOCView` view class, the view portion of a Table of
# Contents component.
#
# @module stout-ui/toc/TOCView
###
defaults = require 'lodash/defaults'
TreeView = require '../tree/TreeView'
vars     = require '../vars'

# Require shared input variables.
require '../vars/toc'


###*
# The table-of-contents custom tag name.
#
# @type string
# @const
# @private
###
TAG_NAME = vars.readPrefixed 'toc/toc-tag'


###*
# The table-of-contents class name.
#
# @type string
# @const
# @private
###
TOC_CLS = vars.read 'toc/toc-class'



###*
# The `TOCView` class represents the view part of a Table of Contents component.
#
# @exports stout-ui/toc/TOCView
# @extends stout-ui/interactive/InteractiveView
# @constructor
###
module.exports = class TOCView extends TreeView

  constructor: (init, events) ->
    defaults init, {tagName: TAG_NAME}
    super init, events

    @prefixedClasses.add TOC_CLS
