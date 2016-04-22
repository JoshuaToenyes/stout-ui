###*
# @overview Defines the `Card` view-model class.
#
# @module stout-ui/card/Card
###
Interactive = require '../interactive/Interactive'



###*
# The `Card` class represents a single content card with generic content.
#
# @exports stout-ui/card/Card
# @extends stout-ui/interactive/Interactive
# @constructor
###
module.exports = class Card extends Interactive

  constructor: ->
    super arguments...
