###*
# @overview Defines the `TOCItem` view-model class.
#
# @module stout-ui/toc/TOCItem
###
TreeItem = require '../tree/TreeItem'



###*
# The `TOCItem` class represents a Table of Contents component's view-model.
#
# @exports stout-ui/toc/TOCItem
# @extends stout-ui/tree/TreeItem
# @constructor
###
module.exports = class TOCItem extends TreeItem

  constructor: ->
    super arguments...
