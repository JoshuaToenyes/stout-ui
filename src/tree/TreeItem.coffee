###*
# @overview Defines the `TreeItem` view-model class.
#
# @module stout-ui/toc/TreeItem
###
Interactive = require '../interactive/Interactive'



###*
# The `TreeItem` class represents a Table of Contents component's view-model.
#
# @exports stout-ui/toc/TreeItem
# @extends stout-ui/interactive/Interactive
# @constructor
###
module.exports = class TreeItem extends Interactive

  constructor: ->
    super arguments...
