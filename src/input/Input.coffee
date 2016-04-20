###*
# @overview Defines the `Input` class, the view-model portion of the Stout UI
# text input component.
#
# @module stout-ui/input/Input
###
EnableableTrait  = require '../interactive/EnableableTrait'
HasLabel         = require '../traits/HasLabel'
HasMaxMinLength  = require '../traits/HasMaxMinLength'
HasValidationMsg = require '../traits/HasValidationMsg'
HasValidators    = require '../traits/HasValidators'
HasValue         = require '../traits/HasValue'
Interactive      = require '../interactive/Interactive'



###*
# The `Input` class is the view-model of a text input component.
#
# @exports stout-ui/input/Input
# @extends stout-ui/interactive/Interactive
# @constructor
###
module.exports = class Input extends Interactive

  @useTrait EnableableTrait
  @useTrait HasLabel
  @useTrait HasMaxMinLength
  @useTrait HasValidationMsg
  @useTrait HasValidators
  @useTrait HasValue, skip: 'value'

  constructor: (init, events = []) ->
    super init, events.concat 'max-length'
    @maxListenerCount 'change', 30
    @maxValidationMessages = 1


  ###*
  # The current input length.
  #
  # @member {number} length
  # @memberof stout-ui/input/Input#
  ###
  @property 'length',
    get: -> @value.length


  ###*
  # The view model's value.
  #
  # @member {mixed} value
  # @memberof stout-ui/traits/HasValue#
  ###
  @property 'value',
    default: ''


  ###*
  # Internal reference to max-length validator. May be accessed by the view.
  #
  # @member {module:stout-ui/validator/MaxLength} maxlengthValidator
  # @memberof stout-ui/input/Input
  # @private
  ###
