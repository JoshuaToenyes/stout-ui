Validator = require 'stout-core/validator/Validator'

module.exports = class HintValidator extends Validator

  constructor: (msg) ->
    super()
    @validation = 'hint'
    @message = msg
