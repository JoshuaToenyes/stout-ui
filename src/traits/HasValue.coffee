###*
# @overview Defines the `HasValue` trait which adds a "value" to a UI component
# view model.
#
# @module stout-ui/traits/HasValue
###
Foundation = require 'stout-core/base/Foundation'



###*
# The `HasValue` trait adds a `value` property which is meant to be a value
# that is user-changeable in the view. This trait should be mirrored in the
# view by the `HasValueView` trait. Other associated properties are also added
# to make working with a user-changeable component easier.
#
# @exports stout-ui/traits/HasValue
# @mixin
###
module.exports = class HasValue extends Foundation

  ###*
  # The view model's value.
  #
  # @member {mixed} value
  # @memberof stout-ui/traits/HasValue#
  ###
  @property 'value'


  ###*
  # Defines the "dirty" property which is true if the value has been changed.
  #
  # @member {boolean} dirty
  # @memberof stout-ui/traits/HasValue#
  ###
  @property 'dirty',
    default: false
    type: 'boolean'
