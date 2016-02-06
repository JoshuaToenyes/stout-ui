##
# Defines the Button component class.
#
# @author Joshua Toenyes <josh@goatriot.com>

dom         = require 'stout/core/utilities/dom'
template    = require 'button/button.jade'
Interactive = require 'stout/ui/common/Interactive'
use         = require 'stout/core/trait/use'
ink         = require 'stout/ui/traits/ink'
fill        = require 'stout/ui/traits/fill'

commonSASS = require '!!sass-variables!vars/common.sass'
buttonSASS = require '!!sass-variables!vars/button.sass'

prefix = commonSASS.prefix
buttonClass = prefix + buttonSASS.buttonPostfix
fillClass = prefix + 'fill'
inkContainerClass = prefix + 'ink-container'
fillContainerClass = prefix + 'fill-container'

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
    @classes.add buttonClass

    if @ink then use(ink) @
    use(fill) @

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
    if @rendered and not @filled @_getFillContainer()
      @fill @_getFillContainer()
      @classes.remove commonSASS.hidden
      @classes.add commonSASS.visible




  ##
  # Removes the fill from the button background, hiding the button.
  #
  # @method hide
  # @override
  # @protected

  hide: ->
    if @rendered and @filled @_getFillContainer()
      @unfill @_getFillContainer()
      @classes.remove commonSASS.visible
      @classes.add commonSASS.hidden



  ##
  # Returns `true` or `false` indicating if this component is currently visible.
  #
  # @method isVisible
  # @public

  isVisible: ->
    @rendered and @class.hasClass commonSASS.visible



  render: ->
    if @label is '' then @iconPosition = 'center'
    super()
    if @ink
      inkContainer = @select ".#{inkContainerClass}"
      @initInkMouseEvents @el, inkContainer
    setTimeout =>
      @fillNow @_getFillContainer(), =>
        @classes.remove commonSASS.hidden
        @classes.add commonSASS.visible
    , 0

  ##
  # Returns the button element.
  #
  # @returns {HTMLElement} The button DOM node.
  #
  # @method _getButton
  # @protected

  _getButton: -> @select 'button'


  # Returns the ink fill container for showing/hiding the button.
  #
  # @returns {DOMElement} The fill container
  #
  # @method _getFillContainer
  # @private

  _getFillContainer: -> @select ".#{fillContainerClass}"


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
