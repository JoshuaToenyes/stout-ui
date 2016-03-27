###*
# @overview Defines the RadioButton class, a standard radio button which is
# capable of being grouped by a group ID.
#
# @module stout-ui/select/SelectBoxView
###
assign              = require 'lodash/assign'
EnableableViewTrait = require '../interactive/EnableableViewTrait'
FillableViewTrait   = require '../fill/FillableViewTrait'
HasLabelViewTrait   = require '../component/HasLabelViewTrait'
InteractiveView     = require '../interactive/InteractiveView'
SelectableViewTrait = require './SelectableViewTrait'
vars                = require '../vars'


# Require necessary shared variables.
require '../vars/select'


###*
# The radio button class applied to the root component.
# @type string
# @const
# @private
###
SELECT_BOX_CLS = vars.read 'select/select-box-class'


###*
# The classname of the element which will act as the displayed selection box,
# or the "indicator."
# @type string
# @const
# @private
###
INDICATOR_CLS = vars.readPrefixed 'select/select-box-indicator-class'


###*
# The class name of the select box label, applied if using the `label` property.
# @type string
# @const
# @private
###
LABEL_CLS = vars.readPrefixed 'select/select-box-label-class'


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
FILL_BOUNDS_CLS = vars.readPrefixed 'select/select-box-fill-bounds'


###*
# The size of the ink ripple, relative to the size of the box (in percent).
# @type number
# @const
# @private
###
INK_SIZE = vars.readNumber 'select/select-box-ink-size'



###*
# The RadioButton class represents a single radio button which may be linked
# to other RadioButton instances to ensure mutual exlusivity.
#
# @param {function} template - The template function to use.
#
# @param {Object} [init] - Initiation object.
#
# @exports stout-ui/select/SelectBoxView
# @extends stout-ui/container/Container
# @constructor
###
module.exports = class SelectBoxView extends InteractiveView

  @useTrait HasLabelViewTrait
  @useTrait EnableableViewTrait
  @useTrait FillableViewTrait
  @useTrait SelectableViewTrait

  constructor: ->
    super arguments...

    @prefixedClasses.add SELECT_BOX_CLS
    @prefixedClasses.add @size
    @prefixedClasses.add @type

    handleSelectionFill = =>
      if @selected then @forceFill() else @unfill()

    @on 'change:selected', handleSelectionFill
    @on 'ready', =>
      handleSelectionFill()
      @_attachSelectBoxViewListeners()

    assign @viewClasses,
      indicator: INDICATOR_CLS
      fillBounds: FILL_BOUNDS_CLS


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
  @property 'type',
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
  # @method _attachSelectBoxViewListeners
  # @memberof stout-ui/select/SelectBoxView#
  # @private
  ###
  _attachSelectBoxViewListeners: ->
    indicator = @select(".#{@viewClasses.indicator}")
    @addEventListener 'tap', @onSelectBoxClick, @
    @addEventListenerTo indicator, 'tap', @_rippleSelectionInk


  ###*
  # Abstract method which must be defined by extending classes to handle the
  # activation event of this select box.
  #
  # @method onSelectBoxClick
  # @memberof stout-ui/select/SelectBoxView#
  # @protected
  # @abstract
  ###


  ###*
  # Shows ink ripple effect emanating from center of select box.
  #
  # @method _rippleSelectionInk
  # @memberof stout-ui/select/SelectBoxView#
  # @private
  ###
  _rippleSelectionInk: =>
    inkContainer = @select(".#{@viewClasses.inkContainer}")
    h = inkContainer.getBoundingClientRect().height
    inkSize = h * INK_SIZE / 100
    if @ink and not @selected
      @rippleInk @select(".#{@viewClasses.inkContainer}"), inkSize
