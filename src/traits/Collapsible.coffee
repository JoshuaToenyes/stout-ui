###*
# @overview
#
# @module stout-ui/traits/CollapsibleTriggerView
###
Foundation        = require 'stout-core/base/Foundation'


###*
#
#
# @exports stout-ui/traits/Collapsible
# @mixin
###
module.exports = class Collapsible extends Foundation

  ###*
  # Property indicating if this item's children can be collapsed. This property
  # has no meaning if this item has no children.
  #
  # @member {boolean} collapsible
  # @memberof stout-ui/traits/CollapsibleTriggerView#
  ###
  @property 'collapsible',
    type: 'boolean'
    default: true


  ###*
  # The current collapsed state of this item. This property has no meaning
  # if it has no children.
  #
  # @member {boolean} collapsible
  # @memberof stout-ui/traits/CollapsibleTriggerView#
  ###
  @property 'collapsed',
    type: 'boolean'
    default: true


  ###*
  # `true` if this Collapsible is currently collapsing.
  #
  # @member {boolean} collapsible
  # @memberof stout-ui/traits/CollapsibleTriggerView#
  ###
  @property 'collapsing',
    type: 'boolean'
    default: false


  ###*
  # `true` if this Collapsible is expanded.
  #
  # @member {boolean} expanded
  # @memberof stout-ui/traits/CollapsibleTriggerView#
  ###
  @property 'expanded',
    type: 'boolean'
    default: true


  ###*
  # `true` if this Collapsible is currently expanding.
  #
  # @member {boolean} expanding
  # @memberof stout-ui/traits/CollapsibleTriggerView#
  ###
  @property 'expanding',
    type: 'boolean'
    default: false
