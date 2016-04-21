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
    @messages.error = 'Invalid character!'


  ###*
  # Timeout for removing the error after @removeTime.
  #
  # @member _errorTimeout
  # @memberof stout-ui/validator/MaxLength
  ###


  maskValidate: ->
    if @_errorTimeout then clearTimeout @_errorTimeout
    @_error()
    @_errorTimeout = setTimeout =>
      @_ok()
    , @removeTime


  clearMaskError: -> @_ok()


  validate: -> @_ok()
