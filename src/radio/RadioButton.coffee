###*
# @overview Defines the RadioButton class, a standard radio button which is
# capable of being grouped by a group ID.
#
# @module stout-ui/radio/RadioButton
###

SelectBox = require '../select/SelectBox'
template   = require './radio-button.template'
vars      = require '../vars'


# Require necessary shared variables.
require '../vars/radio'


###*
# The radio button class applied to the root component.
# @type string
# @const
# @private
###
RADIO_CLS = vars.read 'radio/radio-class'


module.exports = class RadioButton extends SelectBox

  ###*
  # The RadioButton class represents a single radio button which may be linked
  # to other RadioButton instances to ensure mutual exlusivity.
  #
  # @param {Object} [init] - Initiation object.
  #
  # @exports stout-ui/radio/RadioButton
  # @extends stout-ui/container/Container
  # @constructor
  ###
  constructor: (init) ->
    super template, init
    @prefixedClasses.add RADIO_CLS


  ###*
  # Reference to the radio button group this radio button belongs to.
  #
  # @member _group
  # @memberof stout-ui/radio/RadioButton#
  # @type {stout-ui/radio/RadioGroup}
  # @private
  ###


  ###*
  # The radio button group this radio button belongs to.
  #
  # @member group
  # @memberof stout-ui/radio/RadioButton#
  # @type string|number
  ###
  @property 'group',
    get: -> @_group
    set: (group) ->
      if group
        if @_group then @_group.remove @
        group.add @
        @_group = group
