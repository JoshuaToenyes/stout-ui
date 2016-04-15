Validator = require 'stout-core/validation/Validator'

module.exports = class HintValidator extends Validator

  constructor: (msg) ->
    super()
    @validation = 'hint'
    @message = msg

  validate: -> #no-op
