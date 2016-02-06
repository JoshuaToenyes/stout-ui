##
# Defines the Button component class.
#
# @author Joshua Toenyes <josh@goatriot.com>

dom         = require 'stout/core/utilities/dom'
template    = require 'button/button.jade'
Interactive = require 'stout/ui/common/Interactive'
use         = require 'stout/core/trait/use'
ink         = require 'stout/ui/traits/ink'

prefix = require('!!sass-variables!common/vars.sass').prefix
vars = require '!!sass-variables!button/vars.sass'

console.log prefix

##
# Simple Button component class.
#
# @class Button
# @public

module.exports = class Button extends Interactive

  # If this button should use the ink clicking trait.
  #
  # @property {boolean} ink
  # @default true
  # @public

  @property 'ink',
    default: true


  ##
  # The button label.
  #
  # @type string
  # @property label
  # @public

  @property 'label',
    default: ''


  ##
  # SVG string that should be included directly on the page.
  #
  # @type string
  # @property svgIcon
  # @public

  @property 'svgIcon'


  ##
  # Where the icon should appear relative to the icon text.
  #
  # @type string
  # @property iconPosition
  # @public

  @property 'iconPosition',
    default: 'right'
    values: ['left', 'right', 'top', 'bottom', 'center']


  ##
  # Button constructor.
  #
  # @param {object} [init={}] - Initial property values.
  #
  # @param {string} [init.label=''] - Button label.
  #
  # @constructor

  constructor: (init = {}) ->
    super template, null, {renderOnChange: false}, init

    # Add the `sc-button` class to the component container.
    @classes.add prefix + 'button'

    if @ink then use(ink) @

    # Update the label in real-time if it changes.
    @on 'change:label', (e) =>
      @_getButton().textContent = e.data.value


  ##
  # Fills the button with the background color, making it visible.
  #
  # @method show
  # @override
  # @protected

  show: ->
    if @rendered then dom.addClass @_getButton(), prefix + 'fill'


  ##
  # Removes the fill from the button background, hiding the button.
  #
  # @method hide
  # @override
  # @protected

  hide: ->
    if @rendered then dom.removeClass @_getButton(), prefix + 'fill'


  ##
  # Returns `true` or `false` indicating if this component is currently visible.
  #
  # @method isVisible
  # @public

  isVisible: =>
    if @rendered
      dom.hasClass @_getButton(), prefix + 'fill'
    else
      false



  render: ->
    if @label is '' then @iconPosition = 'center'
    super()
    if @ink
      inkContainer = @select ".#{prefix}ink-container"
      @initInkMouseEvents @el, inkContainer


  ##
  # Returns the button element.
  #
  # @returns {HTMLElement} The button DOM node.
  #
  # @method _getButton
  # @protected

  _getButton: -> @select 'button'


  ##
  # Returns the element that should be disabled (the button element).
  #
  # @returns {HTMLElement} The button DOM node.
  #
  # @method _getDisableTarget
  # @override
  # @protected

  _getDisableTarget: @.prototype._getButton


  ##
  # Returns the element that should trigger a hover event (the button element).
  #
  # @returns {HTMLElement} The button DOM node.
  #
  # @method _getHoverTarget
  # @override
  # @protected

  _getHoverTarget: @.prototype._getButton
