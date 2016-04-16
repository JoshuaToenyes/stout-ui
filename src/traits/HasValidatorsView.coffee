###*
# @overview Defines the `HasValidators` trait which adds validation
# messages to a component.
#
# @module stout-ui/input/HasValidators
###
Foundation = require 'stout-core/base/Foundation'
parser     = require '../validators/parser'


###*
# The `HasValidatorsView`
#
# @exports stout-ui/traits/HasValidatorsView
# @mixin
###
module.exports = class HasValidatorsView extends Foundation

  ###*
  # The `validators` attribut on views which include this trait. `Validator`
  # classes are automatically instantiated based on this property.
  #
  # @member validators
  # @memberof stout-ui/traits/HasValidatorsView#
  ###
  @property 'validators',
    default: ''


  ###*
  # Initiates this trait.
  #
  # @method initTrait
  # @memberof stout-ui/traits/HasValidatorsView#
  # @private
  ###
  initTrait: ->
    if @validators.trim().length > 0
      @context.validators.add parser.parse(@validators)...
