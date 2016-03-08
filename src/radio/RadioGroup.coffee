###*
# @overview Defines a radio button group, in-which only a single radio button
# may be selected at a time.
#
# @module stout-ui/radio/RadioGroup
###

assign          = require 'lodash/assign'
forEach         = require 'lodash/forEach'
Component = require '../common/Component'
RadioButton     = require './RadioButton'

# Require necessary shared variables.
require '../vars/radio-group'


###*
# The class applied to the root radio group element.
# @type string
# @const
# @private
###
RADIO_GROUP_CLS = vars.read 'radio-group/radio-group-class'



module.exports = class RadioGroup extends Component

  ###*
  # A mutually exclusive set of radio buttons.
  #
  # @exports stout-ui/radio/RadioGroup
  # @extends stout-core/base/Foundation
  # @constructor
  ###
  constructor: (init) ->
    super null, null, {renderOnChange: false}, init, ['selection']
    @tagName = 'ul'
    @prefixedClasses.add RADIO_GROUP_CLS
    @_members = []


  ###*
  # The currently selected radio button within this group.
  #
  # @member selection
  # @memberof stout-ui/radio/RadioGroup#
  # @type {stout-ui/radio/RadioButton}
  ###
  @property 'selection',
    readonly: true
    get: -> @_selection


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
    if e.source is @_selection then return
    forEach @_members, (m) =>
      if m isnt e.source
        if m is @_selection
          m.unselectBox()
        else
          m._unselect()
    edata =
      selection: e.source
      previous: @_selection
    @_selection = e.source
    @fire 'selection:change', edata


  ###*
  # Adds a radio button to this group.
  #
  # @param {RadioButton} button - The radio button to add to this group.
  #
  # @returns {boolean} `true` if the passed radio button was added, or `false`
  # if the button is was already a member.
  #
  # @method add
  # @memberof stout-ui/radio/RadioGroup#
  ###
  add: (button) ->
    if not @isMember(button)
      @_members.push button
      button.on 'select', @_onSelection
      true
    else
      false


  ###*
  # Creates and adds a new radio button to this radio button group.
  #
  # @param {Object} init - Initiation parameters for the radio button.
  #
  # @returns {stout-ui/radio/RadioButton} The created radio button.
  #
  # @method addButton
  # @memberof stout-ui/radio/RadioGroup#
  ###
  addButton: (init) ->
    assign init,
      group: @
      parent: @root
      tagName: 'li'
    b = new RadioButton init
    @add b
    b


  ###*
  # Returns `true` or `false` to indicate if the passed radio button is a
  # member of this radio group.
  #
  # @param {RadioButton} button - The radio button to check if is a member.
  #
  # @returns {boolean} `true` if the passed radio button is a member of this
  # group, otherwise `false`.
  #
  # @method add
  # @memberof stout-ui/radio/RadioGroup#
  ###
  isMember: (button) ->
    @_members.indexOf(button) isnt -1


  ###*
  # Removes a radio button from group.
  #
  # @param {RadioButton} button - The radio button to remove.
  #
  # @returns {boolean} `true` if the passed radio button was a member of this
  # group and was removed, otherwise `false`.
  #
  # @method remove
  # @memberof stout-ui/radio/RadioGroup#
  ###
  remove: (button) ->
    if not @isMember(button)
      false
    else
      button.off 'select', @_onSelection
      @_members.splice @_members.indexOf(button), 1
      true


  ###*
  # Renders this radio button group and all contained radio buttons.
  #
  # @returns {HTMLElement} The root HTML element for this radio button group.
  #
  # @method render
  # @memberof stout-ui/radio/RadioGroup#
  ###
  render: ->
    r = super()
    for button in @_members
      button.render()
    r
