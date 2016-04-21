###*
# @overview Defines the `HasMask` trait which adds a mask to some component.
#
# @module stout-ui/traits/HasMask
###
Foundation    = require 'stout-core/base/Foundation'
HasValidators = require './HasValidators'
Mask          = require '../mask/Mask'
MaskValidator = require '../validator/Mask'
nextTick      = require 'stout-client/util/nextTick'


###*
# The `HasMask` trait can be used by a component to add a `#mask` property
# and `#rawValue` property.
#
# @exports stout-ui/traits/HasMask
# @mixin
###
module.exports = class HasMask extends Foundation

  ###*
  # The raw value of this component.
  #
  # @member {string} rawValue
  # @memberof stout-ui/traits/HasMask#
  ###
  @property 'rawValue'


  ###*
  # Reference to `Mask` object. Probably instantiated by the view.
  #
  # @member {string} mask
  # @memberof stout-ui/traits/HasMask#
  ###
  @property 'mask'


  ###*
  # Initiates this trait.
  #
  # @method initTrait
  # @memberof stout-ui/traits/HasMask#
  # @private
  ###
  initTrait: ->

    nextTick =>
      if @mask and  @usingTrait HasValidators
        maskval = new MaskValidator
        maskval.name = @validatorName

        @validators.add maskval

        @stream 'validatorName', (n) -> maskval.name = n

        @on 'change:value', ->
          maskval.clearMaskError()

        @mask.on 'invalidinput', (e) ->
          maskval.maskValidate e.data
