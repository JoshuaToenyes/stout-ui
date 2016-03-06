###*
# @overview Defines the RadioButton class, a standard radio button which is
# capable of being grouped by a group ID.
#
# @module stout-ui/select/SelectBox
###

assign     = require 'lodash/assign'
Container  = require '../container/Container'
enableable = require '../interactive/enableable'
fillable   = require '../fill/fillable'
use        = require 'stout-core/trait/use'
vars       = require '../vars'


# Require necessary shared variables.
require '../vars/select-box'


###*
# The radio button class applied to the root component.
# @type string
# @const
# @private
###
SELECT_BOX_CLS = vars.read 'select-box/select-box-class'


###*
# The classname of the element which will act as the displayed selection box,
# or the "indicator."
# @type string
# @const
# @private
###
INDICATOR_CLS = vars.readPrefixed 'select-box/select-box-indicator-class'


###*
# The class name of the select box label, applied if using the `label` property.
# @type string
# @const
# @private
###
LABEL_CLS = vars.readPrefixed 'select-box/select-box-label-class'


###*
# The container classname which will hold the ink fill inside the box.
# @type string
# @const
# @private
###
FILL_CLS = vars.readPrefixed 'fill/fill-container-class'


###*
# A container element which allows for padding between border and inner ink.
# @type string
# @const
# @private
###
FILL_BOUNDS_CLS = vars.readPrefixed 'select-box/select-box-fill-bounds'


###*
# Class applied to root element indicating this box is selected.
# @type string
# @const
# @private
###
SELECTED_CLS = vars.readPrefixed 'select-box/select-box-selected-class'


###*
# The size of the ink ripple, relative to the size of the box (in percent).
# @type number
# @const
# @private
###
INK_SIZE = vars.readNumber 'select-box/select-box-ink-size'


module.exports = class SelectBox extends Container

  ###*
  # The RadioButton class represents a single radio button which may be linked
  # to other RadioButton instances to ensure mutual exlusivity.
  #
  # @param {function} template - The template function to use.
  #
  # @param {Object} [init] - Initiation object.
  #
  # @exports stout-ui/select/SelectBox
  # @extends stout-ui/container/Container
  # @constructor
  ###
  constructor: (template, init) ->
    super template, null, {renderOnChange: false}, init, ['select', 'unselect']

    @prefixedClasses.add SELECT_BOX_CLS
    @prefixedClasses.add @size
    @prefixedClasses.add @style

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
  # @memberof stout-ui/select/SelectBox#
  # @type {stout-ui/radio/RadioGroup}
  # @private
  ###


  ###*
  # If this box should show an ink ripple when clicked.
  #
  # @property {boolean} ink
  # @default true
  # @public
  ###
  @property 'ink',
    default: true


  ###*
  # The label for this select box.
  # @member label
  # @memberof stout-ui/select/SelectBox#
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
  # @memberof stout-ui/select/SelectBox#
  # @type boolean
  # @private
  ###


  ###*
  # Property indicating if this radio button is selected.
  #
  # @member selected
  # @memberof stout-ui/select/SelectBox#
  # @type boolean
  ###
  @property 'selected',
    get: -> @_selected


  ###*
  # The button's size property. Indicates the relative size that this button
  # should be in the user interface. Actual size is determined by the
  # configured control typography sizes in SASS.
  #
  # @property {string} size
  # @default 'normal'
  # @public
  ###
  @property 'size',
    default: 'normal'
    values: [
      'tiny'
      'small'
      'normal'
      'large'
      'huge'
      'massive'
    ]


  ###*
  # The button's style, which indicates how the button should be displayed in
  # the interfaces, as well as it's colors.
  #
  # @property {string} styles
  ###
  @property 'style',
    default: 'default',
    values: [
      'default'
      'inverse'
      'primary'
      'warn'
      'danger'
    ]


  ###*
  # Attaches selection listeners to this radio button.
  #
  # @method _attachSelectBoxListeners
  # @memberof stout-ui/select/SelectBox#
  # @private
  ###
  _attachSelectBoxListeners: ->
    @root.addEventListener 'click', @onSelectBoxClick
    @root.addEventListener 'touchstart', @onSelectBoxClick

    indicator = @select(".#{@viewClasses.indicator}")
    indicator.addEventListener 'click', @_rippleSelectionInk
    indicator.addEventListener 'touchstart', @_rippleSelectionInk


  ###*
  # Abstract method which must be defined by extending classes to handle the
  # activation event of this select box.
  #
  # @method onSelectBoxClick
  # @memberof stout-ui/select/SelectBox#
  # @protected
  # @abstract
  ###


  ###*
  # Shows ink ripple effect emanating from center of select box.
  #
  # @method _rippleSelectionInk
  # @memberof stout-ui/select/SelectBox#
  # @private
  ###
  _rippleSelectionInk: =>
    inkContainer = @select(".#{@viewClasses.inkContainer}")
    h = inkContainer.getBoundingClientRect().height
    inkSize = h * INK_SIZE / 100
    if @ink and not @selected
      @rippleInk @select(".#{@viewClasses.inkContainer}"), inkSize


  ###*
  # Marks this radio button as selected and fills the indicator.
  #
  # @method _unselect
  # @memberof stout-ui/select/SelectBox#
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
  # @memberof stout-ui/select/SelectBox#
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
  # @memberof stout-ui/select/SelectBox#
  ###
  render: ->
    super()
    @show()
    @_attachSelectBoxListeners()


  ###*
  # Marks this radio button as selected, if it is enabled.
  #
  # @method select
  # @memberof stout-ui/select/SelectBox#
  ###
  selectBox: =>
    if @enabled and not @selected
      @fire 'select'
      @_select()


  ###*
  # Unselects this radio button, if it is enabled.
  #
  # @method unselect
  # @memberof stout-ui/select/SelectBox#
  ###
  unselectBox: ->
    if @enabled
      @fire 'unselect'
      @_unselect()
