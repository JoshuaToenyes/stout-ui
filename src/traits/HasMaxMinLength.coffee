###*
# @overview Defines the `HasMaxMinLength` which describes a component which
# can have the `maxlength` and `minlength` attributes/properties.
#
# @module stout-ui/component/HasMaxMinLength
###
Foundation = require 'stout-core/base/Foundation'
MaxLength  = require '../validator/MaxLength'
MinLength  = require '../validator/MinLength'
nextTick   = require 'stout-client/util/nextTick'


###*
# The `HasMaxMinLength` trait defines a component which has `maxlength` and
# `minlength` properties, attributes, and validators. By default, the maxlength
# is set to Infinity and the minlength to zero, so neither is technically
# required.
#
# @exports stout-ui/traits/HasMaxMinLength
# @mixin
###
module.exports = class HasMaxMinLength extends Foundation

  ###*
  # The maximum input length.
  #
  # @member {number} maxlength
  # @memberof stout-ui/traits/HasMaxMinLength#
  ###
  @property 'maxlength',
    default: Infinity
    type: 'number'


  ###*
  # The length when to start warning of approching maximum length.
  #
  # @member {number} maxlengthWarning
  # @memberof stout-ui/traits/HasMaxMinLength#
  ###
  @property 'maxlengthWarning',
    default: Infinity
    type: 'number'


  ###*
  # The minimum input length.
  #
  # @member {number} minlength
  # @memberof stout-ui/traits/HasMaxMinLength#
  ###
  @property 'minlength',
    default: 0
    type: 'number'


  ###*
  # Initiates this trait.
  #
  # @method initTrait
  # @memberof stout-ui/traits/HasMaxMinLength#
  # @private
  ###
  initTrait: ->
    @registerEvents 'maxlength minlength'

    nextTick =>
      minval = new MinLength @minlength
      maxval = new MaxLength @maxlength, @maxlengthWarning
      minval.name = maxval.name = @validatorName

      @validators.add minval, maxval

      @proxyEvents maxval, 'validation', 'maxlength'
      @proxyEvents minval, 'validation', 'minlength'

      @stream 'validatorName', (n) ->
        minval.name = n
        maxval.name = n

      @stream 'maxlength', (l) -> maxval.max = l
      @stream 'minlength', (l) -> minval.min = l
      @stream 'maxlengthWarning', (l) -> maxval.warn = l
