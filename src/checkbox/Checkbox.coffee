###*
# @overview Defines the RadioButton class, a standard radio button which is
# capable of being grouped by a group ID.
#
# @module stout-ui/checkbox/Checkbox
###

SelectBox = require '../select/SelectBox'
template   = require './checkbox.template'
vars      = require '../vars'


# Require necessary shared variables.
require '../vars/checkbox'


###*
# The radio button class applied to the root component.
# @type string
# @const
# @private
###
CHECKBOX_CLS = vars.read 'checkbox/checkbox-class'


module.exports = class Checkbox extends SelectBox

  ###*
  # The Checkbox class represents a single checkbox UI component.
  #
  # @param {Object} [init] - Initiation object.
  #
  # @exports stout-ui/checkbox/Checkbox
  # @extends stout-ui/select/SelectBox
  # @constructor
  ###
  constructor: (init) ->
    super template, init
    @prefixedClasses.add CHECKBOX_CLS


  ###*
  # Checks this checkbox.
  #
  # @method check
  # @memberof stout-ui/checkbox/Checkbox#
  ###
  check: ->
    @selectBox()


  ###*
  # Handles a click on this checkbox.
  #
  # @method onSelectBoxClick
  # @memberof stout-ui/checkbox/Checkbox#
  # @protected
  ###
  onSelectBoxClick: =>
    if @selected then @unselectBox() else @selectBox()


  ###*
  # Unchecks this checkbox.
  #
  # @method uncheck
  # @memberof stout-ui/checkbox/Checkbox#
  ###
  uncheck: ->
    @unselectBox()
