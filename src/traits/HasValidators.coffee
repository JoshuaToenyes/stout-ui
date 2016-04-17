###*
# @overview Defines the `HasValidators` trait which adds validation
# messages to a component.
#
# @module stout-ui/input/HasValidators
###
Foundation          = require 'stout-core/base/Foundation'
HasValidationStates = require 'stout-core/traits/HasValidationStates'
ValidatorGroup      = require 'stout-core/validator/ValidatorGroup'
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


  ###*
  # The current validation state, synced with the validator group.
  #
  # @member {string} validation
  # @memberof stout-ui/traits/HasValidators#
  ###
  @property 'validation'


  ###*
  # Initializes this trait.
  #
  # @member initTrait
  # @memberof stout-ui/traits/HasValidators#
  # @private
  ###
  initTrait: ->
    @validatorGroup = new ValidatorGroup

    # Sync the list of validators and the current validation state with the
    # validators group.
    @syncProperty @validatorGroup, 'validators validation'

    # Proxy all validation events with the validator group.
    @registerEvent 'validation'
    @proxyEvents @validatorGroup, 'validation'

    # When the value changes, perform a soft validation. The primary use case
    # for this is on-the-fly validation as the user is typing.
    @on "change:#{@validateProperty}", (e) =>
      @validatorGroup.softValidate e.data.value
