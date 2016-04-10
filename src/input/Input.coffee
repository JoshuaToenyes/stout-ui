###*
# @overview Defines the `Input` class, the view-model portion of the Stout UI
# text input component.
#
# @module stout-ui/input/Input
###
EnableableTrait = require '../interactive/EnableableTrait'
Interactive     = require '../interactive/Interactive'


###*
# The `Input` class is the view-model component of a text input component.
#
# @exports stout-ui/input/Input
# @extends stout-ui/interactive/Interactive
# @constructor
###
module.exports = class Input extends Interactive

  @useTrait EnableableTrait

  constructor: ->
    super arguments...


  @property 'hint'


  @property 'length',
    get: -> @value.length


  @property 'maxlength',
    default: Infinity
    type: 'number'


  ###*
  # The threshold where a warning should be shown indicating when the maximum
  # length of the input is approaching. This number should be less than 1, as
  # it is a ratio of input characters to the max length.
  #
  # @member {number} maxlengthWarn
  # @memberof stout-ui/input/Input#
  ###
  @property 'maxlengthWarn',
    default: 0.7


  ###*
  # The threshold where an error should be shown indicating when the maximum
  # length of the input has been reached. This number should be less than 1, as
  # it is a ratio of input characters to the max length.
  #
  # @member {number} maxlengthError
  # @memberof stout-ui/input/Input#
  ###
  @property 'maxlengthError',
    default: 0.9


  @property 'value'