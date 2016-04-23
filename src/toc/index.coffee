###*
# @overview Registers the custom card tag.
#
# @module stout-ui/card
###
defaults    = require 'lodash/defaults'
TOC         = require './TOC'
TOCItem     = require './TOCItem'
TOCItemView = require './TOCItemView'
TOCView     = require './TOCView'
parser      = require 'stout-client/parser'

# Read the custom HTML tag.
TOC_TAG_NAME = vars.readPrefixed 'toc/toc-tag'
TOC_ITEM_TAG_NAME = vars.readPrefixed 'toc/toc-item-tag'

# Register the custom tag.
parser.register TOC_TAG_NAME, TOCView, TOC
parser.register TOC_ITEM_TAG_NAME, TOCItemView, TOCItem

module.exports = (init) ->

  factory: (init) ->
    defaults init, {context: new TOC}
    (new TOCView init).context

  itemFactory: (init) ->
    defaults init, {context: new TOCItem}
    (new TOCItemView init).context
