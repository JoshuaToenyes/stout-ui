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

      maskval = null

      showMaskError = (e) -> maskval.showMaskError e.data

      @stream 'validatorName', (n) -> if maskval then maskval.name = n
      @on 'change:value', -> if maskval then maskval.validate()

      # Inner-method to create mask validators.
      createMaskValidator = =>

        # If there is in-fact a mask, and this object has validators...
        if @mask and @usingTrait HasValidators
          if maskval then @validators.remove maskval
          maskval = new MaskValidator
          maskval.name = @validatorName
          @validators.add maskval
          @mask.on 'invalidinput', showMaskError

        # If the mask was removed, removed an existing validator.
        else if maskval
          @validators.remove maskval

      # If the mask changes, create a new mask validator.
      @stream 'mask', createMaskValidator

      # Create the initial mask validator.
      createMaskValidator()
