###*
# @overview Defines the `HasMaskView` trait which adds a mask to some component.
#
# @module stout-ui/traits/HasMaskView
###
Foundation = require 'stout-core/base/Foundation'
isString   = require 'lodash/isString'
Mask       = require '../mask/Mask'



###*
# The `HasMaskView` trait can be used by a component to add a `#mask` property
# and `#rawValue` property.
#
# @exports stout-ui/traits/HasMaskView
# @mixin
###
module.exports = class HasMaskView extends Foundation

  ###*
  # The input mask for this field. Masks can be used to format the input
  # presentation to the user. Examples would include formating phone numbers,
  # credit card numbers, email addresses, etc.
  #
  # @member {module:stout-ui/mask/Mask} mask
  # @memberof stout-ui/traits/HasMaskView#
  ###
  @property 'mask',
    set: (m) ->
      if isString m
        new Mask m
      else
        m


  ###*
  # The `value` property is the value of this input, as presented to the user.
  # This differs from the `rawValue` property which is the unmasked (or
  # mask-removed) value.
  #
  # @member {string} rawValue
  # @memberof stout-ui/traits/HasMaskView#
  ###
  @property 'rawValue',
    get: (v) ->
      if @mask and @value then @mask.raw(@value) else @value
    set: (v) ->
      if v then @value = if @mask then @mask.mask(v) else v


  ###*
  # Initiates this trait.
  #
  # @method initTrait
  # @memberof stout-ui/traits/HasMaskView#
  # @private
  ###
  initTrait: ->
    @syncProperty @context, 'rawValue mask', inherit: false
