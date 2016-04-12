###*
# @overview Defines the `HasValidators` trait which adds validation
# messages to a component.
#
# @module stout-ui/input/HasValidators
###
Foundation          = require 'stout-core/base/Foundation'
HasValidationStates = require 'stout-core/traits/HasValidationStates'
ValidatorAggregate  = require 'stout-core/validation/ValidatorAggregate'
values              = require 'lodash/values'


###*
# The `HasValidators` defines a component which can have validators
# attached. Validators listen for value changes and update the validation
# state as appropriate.
#
# @exports stout-ui/traits/HasValidators
# @mixin
###
module.exports = class HasValidators extends Foundation

  ###*
  # Array of attached validators.
  #
  # @member {Array.<Validator>} validators
  # @memberof stout-ui/traits/HasValidators#
  ###
  @property 'validators'


  ###*
  # The property on "this" object which should be validated.
  #
  # @member {string} validateProperty
  # @memberof stout-ui/traits/HasValidators#
  ###
  @property 'validateProperty',
    default: 'value'


  @property 'validation'


  ###*
  # Initializes this trait.
  #
  # @member initTrait
  # @memberof stout-ui/traits/HasValidators#
  # @private
  ###
  initTrait: ->
    @registerEvent 'validation'
    @_aggregate = new ValidatorAggregate

    @syncProperty @_aggregate, 'validators validation'
    @proxyEvents @_aggregate, 'validation'

    # When the value changes, perform a soft validation. The primary use case
    # for this is on-the-fly validation as the user is typing.
    @on "change:#{@validateProperty}", (e) =>
      @_aggregate.soft e.data.value
