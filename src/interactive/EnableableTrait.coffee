###*
# @overview Defines the EnableableTrait which can be added to view model classes
# to easily enable/disable a component.
#
# @module stout-ui/interactive/EnableableTrait
###

Foundation = require 'stout-core/base/Foundation'



###*
# The EnableableTrait defines a view model which can be enabled or disabled.
# Generally, the class adding this trait should have a view which uses the
# `EnableableViewTrait`, which syncs these properties.
#
# @exports stout-ui/interactive/EnableableTrait
# @mixin
###
module.exports = class EnableableTrait extends Foundation

  ###*
  # The `disabled` property sets or gets if this component is disabled.
  #
  # @member disabled
  # @memberof stout-ui/interactive/EnableableTrait#
  ###
  @property 'disabled',
    default: false
    type: 'boolean'
    get: -> not @enabled
    set: (disable) -> @enabled = not disable


  ###*
  # The `enabled` property sets or gets if this component is enabled.
  #
  # @member enabled
  # @memberof stout-ui/interactive/EnableableTrait#
  ###
  @property 'enabled',
    default: true
    type: 'boolean'


  ###*
  # Disable this view or component.
  #
  # @returns {this}
  #
  # @method disabled
  # @memberof stout-ui/interactive/EnableableTrait#
  ###
  disable: ->
    @disabled = true
    @


  ###*
  # Enables this view or component.
  #
  # @returns {this}
  #
  # @method enable
  # @memberof stout-ui/interactive/EnableableTrait#
  ###
  enable: ->
    @enabled = true
    @
