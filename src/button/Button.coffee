###*
# @overview Defines the button component's view-model class.
#
# @module stout-ui/button/Buton
###
Interactive = require '../interactive/Interactive'
EnableableTrait = require '../interactive/EnableableTrait'


###*
# The `Button` class is a simple view-model class for the button
# component.
#
# @exports stout-ui/button/Button
# @extends stout-ui/interactive/Interactive
# @constructor
###
module.exports = class Button extends Interactive

  @useTrait EnableableTrait

  constructor: -> super arguments...
