###*
# @overview Defines the `InputView` class, the view portion of the Stout UI
# text input component.
#
# @module stout-ui/input/InputView
###
defaults            = require 'lodash/defaults'
EnableableViewTrait = require '../interactive/EnableableViewTrait'
HasHintViewTrait    = require './HasHintViewTrait'
HasLabelViewTrait   = require '../component/HasLabelViewTrait'
Input               = require './Input'
InteractiveView     = require '../interactive/InteractiveView'
isString            = require 'lodash/isString'
keys                = require 'stout-client/keys'
Mask                = require '../mask/Mask'
template            = require './input.template'

# Require shared input variables.
require '../vars/input'


###*
# The input class applied to the root component.
# @type string
# @const
# @private
###
INPUT_CLS = vars.read 'input/input-class'


###*
# This class is added when the input is empty.
# @type string
# @const
# @private
###
EMPTY_CLS = vars.read 'input/input-empty-class'


###*
# The button custom tag name.
# @type string
# @const
# @private
###
TAG_NAME = vars.readPrefixed 'input/input-tag'



###*
# The `InputView` class is the view component of a text input component.
#
# @exports stout-ui/input/InputView
# @extends stout-ui/interactive/InteractiveView
# @constructor
###
module.exports = class InputView extends InteractiveView

  @useTrait EnableableViewTrait
  @useTrait HasHintViewTrait
  @useTrait HasLabelViewTrait

  constructor: (init, events) ->
    defaults init, {template, tagName: TAG_NAME}
    super init, events

    @syncProperty @context, "maxlength maxlengthWarn
    maxlengthError value length", inherit: false

    @prefixedClasses.add INPUT_CLS

    if @empty then @prefixedClasses.add EMPTY_CLS

    @on 'blur', @_onInputBlur, @
    @on 'change:value', @_onValueChange, @

    # Mask the initial value.
    if @mask then @value = @mask.mask @value

  @cloneProperty Input, "length maxlength maxlengthWarn maxlengthError"


  ###*
  # Boolean flag indicating if the key just pressed was the backspace key.
  #
  # @member _wasBackspace
  # @memberof stout-ui/input/InputView#
  ###


  ###*
  # The `empty` property is `true` if the `rawValue` of this input is of zero
  # length.
  #
  # @member empty
  # @memberof stout-ui/input/InputView#
  ###
  @property 'empty',
    readonly: true
    get: -> @value.length is 0


  ###*
  # The input mask for this field. Masks can be used to format the input
  # presentation to the user. Examples would include formating phone numbers,
  # credit card numbers, email addresses, etc.
  #
  # @member {module:stout-ui/mask/Mask} mask
  # @memberof stout-ui/input/InputView#
  ###
  @property 'mask',
    set: (m) ->
      if isString m
        new Mask m
      else
        m


  ###*
  # The min length of this text input.
  #
  # @member {number} minlength
  # @memberof stout-ui/input/InputView#
  ###
  @property 'minlength',
    default: 0
    type: 'number'


  ###*
  # The `value` property is the value of this input, as presented to the user.
  # This differs from the `rawValue` property which is the unmasked (or
  # mask-removed) value.
  #
  # @member {string} rawValue
  # @memberof stout-ui/input/InputView#
  ###
  @property 'rawValue',
    get: (v) -> if @mask then @mask.raw(@value) else @value
    set: (v) ->
      if v
        @value = if @mask then @mask.mask(v) else v


  ###*
  # The `value` property is the value of this input, as presented to the user.
  # This differs from the `rawValue` property which is the unmasked (or
  # mask-removed) value.
  #
  # @member value
  # @memberof stout-ui/input/InputView#
  ###
  @property 'value',
    default: ''
    type: 'string|number'
    set: (v) ->
      v = v.toString()
      if @rendered and not @_wasBackspace then @select('input').value = v
      v


  ###*
  # On-input handler for input element. Is called whenever the input value
  # changes.
  #
  # @method _onInput
  # @memberof stout-ui/input/InputView#
  # @private
  ###
  _onInput: (e) ->
    v = e.target.value
    cursorPos = e.target.selectionStart

    if @mask
      newValue = @mask.mask v
      newCursorPos = @mask.getUpdatedCursorPosition(cursorPos, v, newValue)
    else
      newValue = v
      newCursorPos = cursorPos

    # If the length of the masked value hasn't changed, then
    if newValue.length is @value.length
      newValue = @value

    # Flag indicating if we've exceeded the max length of the mask or input.
    exceededMaxLength = v.length > (@mask?.maxlength or @maxlength)

    # Indicates an invalid character was pressed.
    invalidCharacter = newValue is @value and
    (newCursorPos isnt cursorPos or cursorPos is v.length)

    # Detect if we should indicate an invalid character was entered or the
    # max-length of the input or mask has been reached. If so, don't updated
    # the input's value and "bump" the component to indicate the input
    # character was somehow in-error.
    if exceededMaxLength or
    newValue is @value or
    newValue.length is @value.length
      newValue = @value

      if (newCursorPos isnt cursorPos or exceededMaxLength) or invalidCharacter
        @bump()

    @value = newValue

    # If we've exceeded the max length, and there's no mask to correct the
    # cursor position, manually move it back by one. This handles the case
    # where the user types in-the-middle of a string which has exceeded the
    # maximum input length.
    if exceededMaxLength and not @mask then newCursorPos--

    # Always update the cursor position.
    e.target.setSelectionRange newCursorPos, newCursorPos


  ###*
  # Blur event handler. This method is called when focus moves away from the
  # input.
  #
  # @method _onInputBlur
  # @memberof stout-ui/input/InputView#
  # @private
  ###
  _onInputBlur: ->
    if @value.length is 0
      @prefixedClasses.add EMPTY_CLS
    else
      @prefixedClasses.remove EMPTY_CLS


  ###*
  # Input element keydown event handler.
  #
  # @method _onKeydown
  # @memberof stout-ui/input/InputView#
  # @private
  ###
  _onKeydown: (e) ->
    @_wasBackspace = if e.keyCode is keys.BACKSPACE then true else false


  ###*
  # Handles value property change events.
  #
  # @method _onValueChange
  # @memberof stout-ui/input/InputView#
  # @private
  ###
  _onValueChange: (e) ->
    @length = @value.length

    # Update max-length indicator classes.
    if @maxlength < Infinity
      @prefixedClasses.remove 'max-length max-length-warn'
      if @length / @maxlength > @maxlengthError
        @prefixedClasses.add 'max-length'
      else if @length / @maxlength > @maxlengthWarn
        @prefixedClasses.add 'max-length-warn'


  ###*
  # Override the default focus target and set to the input element.
  #
  # @method getFocusTarget
  # @memberof stout-ui/input/InputView#
  # @override
  ###
  getFocusTarget: -> @select 'input'


  ###*
  # Renders this InputView and attached necessary event listeners.
  #
  # @returns {module:stout-core/promise/Promise} Promise fulfilled when fully
  # rendered and ready for user input.
  #
  # @method render
  # @memberof stout-ui/input/InputView#
  ###
  render: ->
    super().then =>
      input = @select('input')
      input.value = @value

      # Use this boolean flag to help determine if the user is "backspacing"
      @_wasBackspace = false

      # When a key is pressed, check if it's the backspace. If so temporarily
      # disable masking.
      @addEventListenerTo input, 'keydown', @_onKeydown, @

      # When the value of the field changes, mask it.
      @addEventListenerTo input, 'input', @_onInput, @
