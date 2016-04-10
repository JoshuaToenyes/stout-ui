###*
# @overview Defines the `HasHintTrait` which can be added to a view model to
# add a hint property. Works with the `HasHintViewTrait` for the view class.
#
# @module stout-ui/input/HasHintTrait
###
Foundation = require 'stout-core/base/Foundation'



###*
# The HasHintTrait can be used for input-type components which have a hint
# message.
#
# @exports stout-ui/input/HasHintTrait
# @mixin
###
module.exports = class HasHintTrait extends Foundation

  ###*
  # Hint message.
  #
  # @member {string} hint
  # @memberof stout-ui/input/HasHintTrait
  ###
  @property 'hint',
    default: ''
    type: 'string|number'
