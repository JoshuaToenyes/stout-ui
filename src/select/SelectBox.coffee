###*
# @overview Defines the `SelectBox` class, the view-model for a `SelectBoxView`
# component.
#
# @module stout-ui/select/SelectBox
###
EnableableTrait = require '../interactive/EnableableTrait'
Interactive     = require '../interactive/Interactive'
SelectableTrait = require './SelectableTrait'


###*
# The SelectBox class represents the view-model part of a select box component.
#
# @param {Object} [init] - Initiation object.
#
# @param {Array.<string>} [events] - Additional event names to register
# immediately.
#
# @exports stout-ui/select/SelectBox
# @extends stout-ui/interactive/Interactive
# @constructor
###
module.exports = class SelectBox extends Interactive

  @useTrait SelectableTrait
  @useTrait EnableableTrait

  constructor: ->
    super arguments...
