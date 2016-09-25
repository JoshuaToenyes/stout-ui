###*
# @overview Defines the `Checkbox` class, the view-model for a checkbox view
# component.
#
# @module stout-ui/checkbox/Checkbox
###
SelectBox = require '../select/SelectBox'



###*
# The Checkbox class represents a single checkbox UI component view-model.
#
# @param {Object} [init] - Initiation object.
#
# @param {Array.<string>} [events] - Additional event names to register
# immediately.
#
# @exports stout-ui/checkbox/Checkbox
# @extends stout-ui/select/SelectBox
# @constructor
###
module.exports = class Checkbox extends SelectBox

  constructor: ->
    super arguments...


  ###*
  # Checks this checkbox.
  #
  # @method check
  # @memberof stout-ui/checkbox/Checkbox#
  ###
  check: -> @selected = true


  ###*
  # Unchecks this checkbox.
  #
  # @method uncheck
  # @memberof stout-ui/checkbox/Checkbox#
  ###
  uncheck: -> @selected = false
