###*
# @overview Defines the `HasValidationMsgTrait` trait which adds validation
# messages to a component.
#
# @module stout-ui/input/HasValidationMsgTrait
###
Foundation = require 'stout-core/base/Foundation'



###*
#
#
# @exports stout-ui/input/HasValidationMsgTrait
# @mixin
###
module.exports = class HasValidationMsgTrait extends Foundation

  ###*
  # Hint message.
  #
  # @member {string} hint
  # @memberof stout-ui/input/HasHintTrait
  ###
  @property 'hint',
    default: ''
    type: 'string|number'


  ###*
  # The maximum number of validation messages to be displayed. Validation
  # messages will be shown in a FIFO manner. Errors are given higher precedence
  # and displayed above warnings.
  #
  # @member {number} maxValidationMessages
  # @memberof stout-ui/traits/HasValidationMsgViewTrait
  ###
  @property 'maxValidationMessages',
    default: Infinity
    type: 'number'
