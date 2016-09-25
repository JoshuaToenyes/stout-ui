###*
# @overview Defines the RadioButtonView class, the view of a standard radio
# button component.
#
# @module stout-ui/radio/RadioButtonView
###
defaults          = require 'lodash/defaults'
HasLabelViewTrait = require '../component/HasLabelViewTrait'
SelectBoxView     = require '../select/SelectBoxView'
template          = require './radio-button.template'
vars              = require '../vars'

# Require necessary shared variables.
require '../vars/radio-button'


###*
# The radio button class applied to the root component.
# @type string
# @const
# @private
###
RADIO_CLS = vars.read 'radio-button/radio-button-class'


###*
# The custom radio button tag name.
# @type string
# @const
# @private
###
TAG_NAME = vars.readPrefixed 'radio-button/radio-button-tag'



###*
# Represents a single radio button view.
#
# @param {Object} [init] - Initiation object.
#
# @param {Array.<string>} [events] - Additional event names to register
# immediately.
#
# @exports stout-ui/radio/RadioButtonView
# @extends stout-ui/select/SelectBoxView
# @constructor
###
module.exports = class RadioButtonView extends SelectBoxView

  @useTrait HasLabelViewTrait

  constructor: (init, events) ->
    defaults init, {template, tagName: TAG_NAME}
    super init, events
    @prefixedClasses.add RADIO_CLS


  ###*
  # Handles a click on this checkbox.
  #
  # @method onSelectBoxClick
  # @memberof stout-ui/checkbox/Checkbox#
  # @protected
  ###
  onSelectBoxClick: => @selected = true
