###*
# @overview Defines the RadioButton class, a standard radio button which is
# capable of being grouped by a group ID.
#
# @module stout-ui/radio/RadioButton
###

assign    = require 'lodash/assign'
Container = require '../container/Container'
vars      = require '../vars'
template  = require './radio-button.template'
use       = require 'stout-core/trait/use'
fillable  = require '../fill/fillable'
enableable = require '../interactive/enableable'

# Require necessary shared variables.
require '../vars/radio'


###*
# The radio button class applied to the root component.
# @type string
# @const
# @private
###
RADIO_CLS = vars.read 'radio/radio-class'


###*
# The classname of the element which will act as the displayed radio button,
# or the "indicator."
# @type string
# @const
# @private
###
INDICATOR_CLS = vars.readPrefixed 'radio/radio-indicator-class'


###*
# The class name of the radio button label, applied if using the radio buttons
# `label` property.
# @type string
# @const
# @private
###
LABEL_CLS = vars.readPrefixed 'radio/radio-label-class'


###*
# The container classname which will hold the ink fill inside the radio button.
# @type string
# @const
# @private
###
FILL_CLS = vars.readPrefixed 'fill/fill-container-class'


###*
#
# @type string
# @const
# @private
###
FILL_BOUNDS_CLS = vars.readPrefixed 'radio/radio-fill-bounds'


###*
# Class applied to root element indicating this radio button is selected.
# @type string
# @const
# @private
###
SELECTED_CLS = vars.readPrefixed 'radio/radio-selected-class'


module.exports = class RadioButton extends Container

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
    super template, null, {renderOnChange: false}, init, ['select', 'unselect']
    @prefixedClasses.add RADIO_CLS

    use(enableable) @
    use(fillable) @

    @_selected = false

    @on 'change:contents', => @_label = undefined

    assign @viewClasses,
      indicator: INDICATOR_CLS
      label: LABEL_CLS
      fillBounds: FILL_BOUNDS_CLS


  ###*
  # Plain label text.
  #
  # @member _label
  # @memberof stout-ui/radio/RadioButton#
  # @type {stout-ui/radio/RadioGroup}
  # @private
  ###


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


  ###*
  # If this radio button should show an ink "cloud" when clicked.
  #
  # @property {boolean} ink
  # @default true
  # @public
  ###
  @property 'ink',
    default: true


  ###*
  # The label for this radio button.
  # @member label
  # @memberof stout-ui/radio/RadioButton#
  # @type string
  ###
  @property 'label',
    default: ''
    get: -> @_label
    set: (l) ->
      @contents = "<span class=#{LABEL_CLS}>#{l}</span>"
      @_label = l


  ###*
  # Private internal property indicating if this radio button is selected.
  #
  # @member _selected
  # @memberof stout-ui/radio/RadioButton#
  # @type boolean
  # @private
  ###


  ###*
  # Property indicating if this radio button is selected.
  #
  # @member selected
  # @memberof stout-ui/radio/RadioButton#
  # @type boolean
  ###
  @property 'selected',
    get: -> @_selected


  ###*
  # Attaches selection listeners to this radio button.
  #
  # @method _attachRadioListeners
  # @memberof stout-ui/radio/RadioButton#
  # @private
  ###
  _attachRadioListeners: ->
    @root.addEventListener 'click', @onSelect
    @root.addEventListener 'touchstart', @onSelect


  ###*
  # Marks this radio button as selected and fills the indicator.
  #
  # @method _unselect
  # @memberof stout-ui/radio/RadioButton#
  # @private
  ###
  _select: ->
    @_selected = true
    @classes.add SELECTED_CLS
    @forceFill()


  ###*
  # Unselects this radio button and unfills the indicator.
  #
  # @method _unselect
  # @memberof stout-ui/radio/RadioButton#
  # @private
  ###
  _unselect: ->
    @_selected = false
    @classes.remove SELECTED_CLS
    @unfill()


  ###*
  # Renders the radio button and adds necessary click listeners.
  #
  # @method render
  # @memberof stout-ui/radio/RadioButton#
  ###
  render: ->
    super()
    @show()
    @_attachRadioListeners()
    if @ink then @initInkMouseEvents @select ".#{@viewClasses.indicator}"


  ###*
  # Marks this radio button as selected, if it is enabled.
  #
  # @method select
  # @memberof stout-ui/radio/RadioButton#
  ###
  onSelect: =>
    if @enabled and not @selected
      @fire 'select'
      @_select()


  ###*
  # Unselects this radio button, if it is enabled.
  #
  # @method unselect
  # @memberof stout-ui/radio/RadioButton#
  ###
  onUnselect: ->
    if @enabled
      @fire 'unselect'
      @_unselect()
