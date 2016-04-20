###*
# @overview Defines the `HasMask` trait which adds a mask to some component.
#
# @module stout-ui/traits/HasMask
###
Foundation = require 'stout-core/base/Foundation'
Mask       = require '../mask/Mask'



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
  # @memberof stout-ui/traits/HasMask
  ###
  @property 'rawValue'
