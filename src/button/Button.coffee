###*
# @overview Defines the Button component class.
#
# @module stout-ui/button/Button
###

dom         = require 'stout-core/utilities/dom'
template    = require './button.template'
Interactive = require '../common/Interactive'
use         = require 'stout-core/trait/use'
fillable    = require '../fill/fillable'
vars        = require '../vars'
enableable  = require '../interactive/enableable'

# Require necessary shared variables.
require '../vars/button'


###*
# The button class applied to the root component.
# @type string
# @const
# @private
###
BUTTON_CLS = vars.read 'button/button-class'


###*
#
# @type string
# @const
# @private
###
INK_CONTAINER_CLS = vars.readPrefixed 'ink/ink-container-class'



module.exports = class Button extends Interactive

  ###*
  # Interactive button component which can be multiple sizes and styles.
  #
  # @param {object} [init={}] - Initial property values.
  #
  # @exports stout-ui/button/Button
  # @extends stout-ui/common/Interactive
  # @constructor
  ###
  constructor: (init = {}) ->
    super template, null, {renderOnChange: false}, init

    @prefixedClasses.add BUTTON_CLS
    @prefixedClasses.add @size
    @prefixedClasses.add @style

    use(enableable) @,
      map:
        enable: '_enable'
        disable: '_disable'
    use(fillable) @

    # Update the label in real-time if it changes.
    @on 'change:label', (e) =>
      @_getButton().textContent = e.data.value

    if @blurOnClick then @on 'click', (e) => @_getButton().blur()


  ###*
  # If set to `true`, this button will blur immediately after a click event.
  # In other words, the button does not keep focus after it has been clicked.
  # This should be set to false if the button is intended to be clicked
  # multiple times, like in a game interfacer.
  #
  # @property {boolean} blurOnClick
  # @default true
  # @public
  ###
  @property 'blurOnClick',
    default: true


  ###*
  # Where the icon should appear relative to the icon text.
  #
  # @type string
  # @property iconPosition
  # @public
  ###
  @property 'iconPosition',
    default: 'right'
    values: ['left', 'right', 'top', 'bottom', 'center']


  ###*
  # If this button should use the ink clicking trait.
  #
  # @property {boolean} ink
  # @default true
  # @public
  ###
  @property 'ink',
    default: true


  ###*
  # The button label.
  #
  # @type string
  # @property label
  # @public
  ###
  @property 'label',
    default: ''


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
    default: 'normal',
    values: [
      'normal'
      'inverse'
      'primary'
      'warn'
      'danger'
      'normal-flat'
      'inverse-flat'
      'primary-flat'
      'warn-flat'
      'danger-flat'
    ]


  ###*
  # SVG string that should be included directly on the page.
  #
  # @type string
  # @property svgIcon
  # @public
  ###
  @property 'svgIcon'


  ###*
  # Returns the button element.
  #
  # @returns {HTMLElement} The button DOM node.
  #
  # @method _getButton
  # @protected
  ###
  _getButton: -> @select 'button'


  ###*
  # Returns the element that should be disabled (the button element).
  #
  # @returns {HTMLElement} The button DOM node.
  #
  # @method _getDisableTarget
  # @override
  # @protected
  ###
  _getDisableTarget: @.prototype._getButton


  ###*
  # Disables the button.
  #
  #
  ###
  disable: ->
    if @rendered and @enabled then @unfill()
    @_disable()


  ###*
  # Enables the button.
  #
  #
  ###
  enable: ->
    if @rendered and @disabled
      @_enable()
      @emptyFill()
      @fill()


  ###*
  # Returns the element that should trigger a hover event (the button element).
  #
  # @returns {HTMLElement} The button DOM node.
  #
  # @method getHoverTarget
  # @override
  # @protected
  ###
  #getHoverTarget: @.prototype._getButton


  ###*
  # Returns the element that should trigger focus and blur events (the button
  # element).
  #
  # @returns {HTMLElement} The button DOM node.
  #
  # @method getFocusTarget
  # @override
  # @protected
  ###
  getFocusTarget: @.prototype._getButton


  ###*
  # Removes the fill from the button background, hiding the button.
  #
  # @method hide
  # @override
  # @protected
  ###
  hide: ->
    if @rendered and @filled()
      @unfill()
      super()


  ###*
  # Returns `true` or `false` indicating if this component is currently hidden.
  #
  # @method isHidden
  # @public
  ###
  isHidden: -> !@isVisible()


  ###*
  # Returns `true` or `false` indicating if this component is currently visible.
  #
  # @method isVisible
  # @public
  ###
  isVisible: ->
    @rendered and @class.hasClass 'visible'


  ###*
  # Fills the button with the background color, making it visible.
  #
  # @method show
  # @override
  # @protected
  ###
  show: ->
    if @rendered and not @filled()
      @fill()
      super()


  ###*
  # Renders the button to the DOM.
  ###
  render: ->
    if @label is '' then @iconPosition = 'center'
    super()
    if @ink then @initInkMouseEvents @_getButton()
    @show()
    @root
