###*
# @overview Defines the `TOC` view-model class.
#
# @module stout-ui/toc/TOC
###
Tree = require '../tree/Tree'



###*
# The `TOC` class represents a Table of Contents component's view-model.
#
# @exports stout-ui/toc/TOC
# @extends stout-ui/tree/Tree
# @constructor
###
module.exports = class TOC extends Tree

  constructor: ->
    super arguments...
