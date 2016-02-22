##
# Defines the Button component class.
#
# @author Joshua Toenyes <josh@goatriot.com>

dom         = require 'stout-core/utilities/dom'
template    = require './button.template'
Interactive = require '../common/Interactive'
use         = require 'stout-core/trait/use'
ink         = require '../traits/ink'
fill        = require '../traits/fill'
#commonSASS  = require '!!sass-variables!vars/common.sass'
#buttonSASS  = require '!!sass-variables!vars/button.sass'

#require 'button/button.sass'
#require 'ink/ink.sass'
#require 'fill/fill.sass'
#require 'indicator/indicator.sass'

prefix = 'ui-' #commonSASS.prefix
buttonClass = prefix + 'button' #buttonSASS.buttonPostfix
fillClass = prefix + 'fill'
inkContainerClass = prefix + 'ink-container'
fillContainerClass = prefix + 'fill-container'

##
# Simple Button component class.
#
# @class Button
# @public

module.exports = class Button extends Interactive

  # The button's size property. Indicates the relative size that this button
  # should be in the user interface. Actual size is determined by the
  # configured control typography sizes in SASS.
  #
  # @property {string} size
  # @default 'normal'
  # @public

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


  # The button's style, which indicates how the button should be displayed in
  # the interfaces, as well as it's colors.
  #
  # @property {string} styles

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


  # If set to `true`, this button will blur immediately after a click event.
  # In other words, the button does not keep focus after it has been clicked.
  # This should be set to false if the button is intended to be clicked
  # multiple times, like in a game interfacer.
  #
  # @property {boolean} blurOnClick
  # @default true
  # @public

  @property 'blurOnClick',
    default: true


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
    @classes.add 'sz-' + @size
    @classes.add 'st-' + @style

    if @ink then use(ink) @
    use(fill) @

    # Update the label in real-time if it changes.
    @on 'change:label', (e) =>
      @_getButton().textContent = e.data.value

    if @blurOnClick then @on 'click', (e) => @_getButton().blur()


  ##
  # Fills the button with the background color, making it visible.
  #
  # @method show
  # @override
  # @protected

  show: ->
    if @rendered and not @filled @_getFillContainer()
      @fill @_getFillContainer()
      @classes.remove 'hidden'
      @classes.add 'visible'




  ##
  # Removes the fill from the button background, hiding the button.
  #
  # @method hide
  # @override
  # @protected

  hide: ->
    if @rendered and @filled @_getFillContainer()
      @unfill @_getFillContainer()
      @classes.remove 'visible'
      @classes.add 'hidden'



  ##
  # Returns `true` or `false` indicating if this component is currently visible.
  #
  # @method isVisible
  # @public

  isVisible: ->
    @rendered and @class.hasClass 'visible'



  render: ->
    if @label is '' then @iconPosition = 'center'
    super()
    if @ink
      inkContainer = @select ".#{inkContainerClass}"
      @initInkMouseEvents @_getButton(), inkContainer
    setTimeout =>
      @fillNow @_getFillContainer(), =>
        @classes.remove 'hidden'
        @classes.add 'visible'
    , 0
    @


  enable: ->
    super()
    @fill? @_getFillContainer()


  disable: ->
    @unfill? @_getFillContainer()
    super()


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
