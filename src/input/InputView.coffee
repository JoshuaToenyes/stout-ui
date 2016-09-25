###*
# @overview Defines the `InputView` class, the view portion of the Stout UI
# text input component.
#
# @module stout-ui/input/InputView
###
defaults             = require 'lodash/defaults'
EnableableViewTrait  = require '../interactive/EnableableViewTrait'
HasLabelViewTrait    = require '../component/HasLabelViewTrait'
HasMaskView          = require '../traits/HasMaskView'
HasMaxMinLengthView  = require '../traits/HasMaxMinLengthView'
HasValidationMsgView = require '../traits/HasValidationMsgView'
HasValidatorsView    = require '../traits/HasValidatorsView'
HasValueView         = require '../traits/HasValueView'
Input                = require './Input'
InteractiveView      = require '../interactive/InteractiveView'
isString             = require 'lodash/isString'
keys                 = require 'stout-client/keys'
template             = require './input.template'
vars                 = require '../vars'

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
  @useTrait HasLabelViewTrait
  @useTrait HasMaskView
  @useTrait HasMaxMinLengthView
  @useTrait HasValidationMsgView
  @useTrait HasValidatorsView
  @useTrait HasValueView

  constructor: (init, events) ->
    defaults init, {template, tagName: TAG_NAME}
    super init, events

    @syncProperty @context, 'length', inherit: false

    @prefixedClasses.add INPUT_CLS

    if @empty then @prefixedClasses.add EMPTY_CLS

    @on 'blur', @_onInputBlur, @
    @on 'change:value', @_onValueChange, @

    # Mask the initial value.
    if @mask then @value = @mask.mask @value

    @on 'set:value', (e) =>
      v = e.data.value.toString()
      if @rendered and not @_wasBackspace then @select('input').value = v

    @context.on 'maxlength:ok', =>
      @prefixedClasses.remove 'max-length-warn max-length'

    @context.on 'maxlength:error', =>
      @prefixedClasses.remove 'max-length-warn'
      @prefixedClasses.add 'max-length'

    @context.on 'maxlength:warning', =>
      @prefixedClasses.remove 'max-length'
      @prefixedClasses.add 'max-length-warn'

  @cloneProperty Input, 'length'


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
  # Increase the max listener count prior to traits being initialized.
  #
  # @method _preTraitInit
  # @memberof stout-ui/input/InputView#
  # @private
  ###
  _preTraitInit: ->
    @maxListenerCount 'change', 30


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
    v isnt newValue and
    (newCursorPos isnt cursorPos or cursorPos is v.length)

    # Detect if we should indicate an invalid character was entered or the
    # max-length of the input or mask has been reached. If so, don't updated
    # the input's value and "bump" the component to indicate the input
    # character was somehow in-error.
    if exceededMaxLength or
    newValue is @value or
    newValue.length is @value.length
      originalValue = newValue
      newValue = @value

      if invalidCharacter and not @_wasBackspace
        @bump 'mask', originalValue

      else if (newCursorPos isnt cursorPos or exceededMaxLength) and
      not @_wasBackspace
        @bump 'maxlength', originalValue

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
