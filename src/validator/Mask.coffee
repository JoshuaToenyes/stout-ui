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
module.exports = class Mask extends Validator

  constructor: (@removeTime = 3000) ->
    super()
    @messages.error = 'Sorry, ":char" is an invalid character.'


  ###*
  # The last character that produced an error.
  #
  # @member {string} char
  # @memberof stout-ui/validator/Mask#
  ###
  @property 'char'


  ###*
  # Timeout for removing the error after @removeTime.
  #
  # @member _errorTimeout
  # @memberof stout-ui/validator/Mask#
  ###


  ###*
  # Method used to show a mask error when an invalid character is input.
  #
  # @member showMaskError
  # @memberof stout-ui/validator/Mask#
  ###
  showMaskError: (v) ->
    @char = v[v.length - 1]
    if @_errorTimeout then clearTimeout @_errorTimeout
    @_error()
    @_errorTimeout = setTimeout =>
      @_ok()
    , @removeTime


  ###*
  # Clears a mask validation. Mask inputs are special in-that it's impossible
  # for a user to input an invalid value. Therefore, the errors show are purely
  # for user feedback.
  #
  # @member validate
  # @memberof stout-ui/validator/Mask#
  ###
  validate: -> @_ok()
