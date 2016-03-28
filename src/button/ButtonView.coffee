###*
# @overview Defines the ButtonView class, the View portion of a Button
# component in an MVVM architecture.
#
# @module stout-ui/button/ButtonView
###
defaults            = require 'lodash/defaults'
EnableableViewTrait = require '../interactive/EnableableViewTrait'
FillableViewTrait   = require '../fill/FillableViewTrait'
FocusableViewTrait  = require '../interactive/FocusableViewTrait'
HasLabelViewTrait   = require '../component/HasLabelViewTrait'
InteractiveView     = require '../interactive/InteractiveView'
template            = require './button.template'

# Require shared button variables.
require '../vars/button'


###*
# The button class applied to the root component.
# @type string
# @const
# @private
###
BUTTON_CLS = vars.read 'button/button-class'


###*
# The button custom tag name.
# @type string
# @const
# @private
###
TAG_NAME = vars.readPrefixed 'button/button-tag'



###*
# Interactive button component.
#
# @param {object} [init={}] - Initial property values.
#
# @exports stout-ui/button/ButtonView
# @extends stout-ui/interactive/InteractiveView
# @constructor
###
module.exports = class ButtonView extends InteractiveView

  @useTrait HasLabelViewTrait
  @useTrait EnableableViewTrait
  @useTrait FillableViewTrait
  @useTrait FocusableViewTrait

  constructor: (init, events) ->
    defaults init, {template, tagName: TAG_NAME}
    super init, events

    @prefixedClasses.add BUTTON_CLS
    @prefixedClasses.add @size
    @prefixedClasses.add @type

    @on 'hide disable', => @unfill()

    @on 'show enable ready', =>
      @emptyFill()
      @fill()

    @on 'ready', => @initInkMouseEvents()

    @on 'active:keydown', => @rippleInk(null, null, 300)


  ###*
  # If set to `true`, this button will blur immediately after a click event.
  # In other words, the button does not keep focus after it has been clicked.
  # This should be set to false if the button is intended to be clicked
  # multiple times, like in a game interfacer.
  #
  # @todo Implement this behavior, if still desired.
  #
  # @member {boolean} blurOnClick
  # @default true
  # @memberof stout-ui/button/ButtonView#
  ###
  @property 'blurOnClick',
    default: true


  ###*
  # The button's size property. Indicates the relative size that this button
  # should be in the user interface. Actual size is determined by the
  # configured control typography sizes in SASS.
  #
  # @member {string} size
  # @default 'normal'
  # @memberof stout-ui/button/ButtonView#
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
  # @member {string} type
  # @default 'normal'
  # @memberof stout-ui/button/ButtonView#
  ###
  @property 'type',
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
