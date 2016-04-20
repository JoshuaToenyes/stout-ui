###*
# @overview Defines the `HasMaxMinLength` which describes a component which
# can have the `maxlength` and `minlength` attributes/properties.
#
# @module stout-ui/component/HasMaxMinLength
###
Foundation = require 'stout-core/base/Foundation'
MaxLength  = require '../validator/MaxLength'
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
  # Minimum length warnings are displayed for inputs below this length.
  #
  # @member {number} minlengthWarning
  # @memberof stout-ui/traits/HasMaxMinLength#
  ###
  @property 'minlengthWarning',
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
    nextTick =>
      mxval = new MaxLength @maxlength, @maxlengthWarning
      mxval.name = @validatorName
      @validators.add mxval

      @proxyEvents mxval, 'validation', 'max-length'

      @stream 'validatorName', (n) -> mxval.name = n
      @stream 'maxlength', (l) -> mxval.max = l
      @stream 'maxlengthWarning', (l) -> mxval.warn = l
