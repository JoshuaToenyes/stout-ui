###*
# @overview Defines a radio button group, in-which only a single radio button
# may be selected at a time.
#
# @module stout-ui/radio/RadioGroup
###
assign      = require 'lodash/assign'
Component   = require '../component/Component'
forEach     = require 'lodash/forEach'
List        = require 'stout-core/collection/List'

# Require necessary shared variables.
require '../vars/radio-group'


###*
# The class applied to the root radio group element.
# @type string
# @const
# @private
###
RADIO_GROUP_CLS = vars.read 'radio-group/radio-group-class'


###*
# The view-model for a mutually exclusive set of radio buttons.
#
# @exports stout-ui/radio-group/RadioGroup
# @extends stout-core/component/Component
# @constructor
###
module.exports = class RadioGroup extends Component

  constructor: (init) ->
    super arguments...
    @_list = new List()


  ###*
  # The currently selected radio button within this group.
  #
  # @member selection
  # @memberof stout-ui/radio/RadioGroup#
  # @type {stout-ui/radio/RadioButton}
  ###
  @property 'selection'


  ###*
  # Handles a selection event for a contained radio button.
  #
  # @param {stout-core/event/Event} e - The selection event from a RadioButton
  # object.
  #
  # @member _onSelection
  # @memberof stout-ui/radio/RadioGroup#
  # @private
  ###
  _onSelection: (e) =>

    # Catch explicit `unselect()` calls and clear this group's `selected`
    # property.
    e.source.once 'unselect', (e) =>
      if @selection is e.source then @selection = undefined

    # Update selection and unselect all other radio buttons.
    if e.source isnt @selection
      @_list.all (b) -> if b isnt e.source then b.unselect()
      @selection = e.source


  ###*
  # Adds a radio button to this group.
  #
  # @param {RadioButton} button - The radio button to add to this group.
  #
  # @method add
  # @memberof stout-ui/radio/RadioGroup#
  ###
  add: (button) ->
    if not @_list.contains button
      @_list.add button
      button.on 'select', @_onSelection


  ###*
  # Removes a radio button from group.
  #
  # @param {RadioButton} button - The radio button to remove.
  #
  # @method remove
  # @memberof stout-ui/radio/RadioGroup#
  ###
  remove: (button) ->
    if @_list.contains button
      button.off 'select', @_onSelection
      @_list.remove button
