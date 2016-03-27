###*
# @overview Defines the CheckboxView class, the view part of the checkbox MVVM.
#
# @module stout-ui/checkbox/CheckboxView
###
defaults      = require 'lodash/defaults'
SelectBoxView = require '../select/SelectBoxView'
template      = require './checkbox.template'
vars          = require '../vars'

# Require necessary shared variables.
require '../vars/checkbox'


###*
# The checkbox class applied to the root component.
# @type string
# @const
# @private
###
CHECKBOX_CLS = vars.read 'checkbox/checkbox-class'


###*
# The custom checkbox tag name.
# @type string
# @const
# @private
###
TAG_NAME = vars.readPrefixed 'checkbox/checkbox-tag'


###*
# The CheckboxView class represents the view part of a single checkbox
# UI component.
#
# @param {Object} [init] - Initiation object.
#
# @param {Array.<string>} [events] - Additional event names to register
# immediately.
#
# @exports stout-ui/checkbox/CheckboxView
# @extends stout-ui/select/SelectBoxView
# @constructor
###
module.exports = class CheckboxView extends SelectBoxView

  constructor: (init, events) ->
    defaults init, {template, tagName: TAG_NAME}
    super init, events
    @prefixedClasses.add CHECKBOX_CLS


  ###*
  # Handles a click on this checkbox.
  #
  # @method onSelectBoxClick
  # @memberof stout-ui/checkbox/Checkbox#
  # @protected
  ###
  onSelectBoxClick: -> @toggleSelected()
