###*
# @overview Defines the `Tree` view-model class.
#
# @module stout-ui/toc/Tree
###
Interactive = require '../interactive/Interactive'



###*
# The `Tree` class represents a Table of Contents component's view-model.
#
# @exports stout-ui/toc/Tree
# @extends stout-ui/interactive/Interactive
# @constructor
###
module.exports = class Tree extends Interactive

  constructor: ->
    super arguments...
