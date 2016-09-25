###*
# @overview Defines the RadioButton class, the view-model of a radio button.
#
# @module stout-ui/radio/RadioButton
###
SelectBox = require '../select/SelectBox'



###*
# The RadioButton class represents a single radio button which may be linked
# to other RadioButton instances to ensure mutual exlusivity.
#
# @param {Object} [init] - Initiation object.
#
# @param {Array.<string>} [events] - Additional event names to register
# immediately.
#
# @exports stout-ui/radio/RadioButton
# @extends stout-ui/container/Container
# @constructor
###
module.exports = class RadioButton extends SelectBox

  constructor: ->
    super arguments...


  ###*
  # The radio button group this radio button belongs to.
  #
  # @member {RadioGroup} group
  # @memberof stout-ui/radio/RadioButton#
  ###
  @property 'group',
    set: (group) ->
      if group
        if @group then @group.remove @
        group.add @
        group
