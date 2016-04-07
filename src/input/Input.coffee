###*
# @overview Defines the `Input` class, the view-model portion of the Stout UI
# text input component.
#
# @module stout-ui/input/Input
###
EnableableTrait = require '../interactive/EnableableTrait'
Interactive     = require '../interactive/Interactive'


###*
# The `Input` class is the view-model component of a text input component.
#
# @exports stout-ui/input/Input
# @extends stout-ui/interactive/Interactive
# @constructor
###
module.exports = class Input extends Interactive

  @useTrait EnableableTrait

  constructor: ->
    super arguments...


  @property 'mask'


  @property 'hint'
