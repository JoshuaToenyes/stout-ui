###*
# @overview Defines the MinLength validator.
#
# @module stout-ui/validator/MinLength
###
Validator = require 'stout-core/validator/Validator'



###*
# The `MinLength` validator can be used for giving user feedback on
# length-restricted text fields.
#
#
# @exports stout-ui/validator/MinLength
# @extends stout-core/validator/Validator
# @constructor
###
module.exports = class MinLength extends Validator

  constructor: (min) ->
    super min: min
    @messages.error = 'Must be at least :min characters.'


  ###*
  # The maximum number of characters allowed for this validator.
  #
  # @member {number} max
  # @memberof stout-ui/validator/MinLength
  ###
  @property 'min'


  ###*
  # The `#softValidate()` method is used to clear an existing validation error
  # triggered by the `#validate()` method. The idea here, is that you don't
  # want every field with a minlength to error immediately when the user starts
  # typing. We only want min-length feedback when blurring the input, then
  # want it to clear as-soon-as the min-length is reached.
  #
  # @param {mixed} v - The value to validate.
  #
  # @method softValidate
  # @memberof stout-ui/validator/MinLength#
  ###
  softValidate: (v) ->
    if v.length >= @min then @_ok()


  ###*
  # Hard validation for min length.
  #
  # @param {mixed} v - The value to validate.
  #
  # @method validate
  # @memberof stout-ui/validator/MinLength#
  ###
  validate: (v) ->
    if v.length < @min
      @_error()
    else
      @_ok()
