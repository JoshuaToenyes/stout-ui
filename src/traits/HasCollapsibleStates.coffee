###*
# @overview
#
# @module stout-ui/traits/HasCollapsibleStates
###
Foundation        = require 'stout-core/base/Foundation'


###*
#
#
# @exports stout-ui/traits/HasCollapsibleStates
# @mixin
###
module.exports = class HasCollapsibleStates extends Foundation

  ###*
  # Property indicating if this item's children can be collapsed. This property
  # has no meaning if this item has no children.
  #
  # @member {boolean} collapsible
  # @memberof stout-ui/traits/HasCollapsibleStates#
  ###
  @property 'collapsible',
    type: 'boolean'
    default: true


  ###*
  # The current collapsed state of this item. This property has no meaning
  # if it has no children.
  #
  # @member {boolean} collapsible
  # @memberof stout-ui/traits/HasCollapsibleStates#
  ###
  @property 'collapsed',
    type: 'boolean'
    default: true


  ###*
  # `true` if this Collapsible is currently collapsing.
  #
  # @member {boolean} collapsible
  # @memberof stout-ui/traits/HasCollapsibleStates#
  ###
  @property 'collapsing',
    type: 'boolean'
    default: false


  ###*
  # `true` if this Collapsible is expanded.
  #
  # @member {boolean} expanded
  # @memberof stout-ui/traits/HasCollapsibleStates#
  ###
  @property 'expanded',
    type: 'boolean'
    default: false


  ###*
  # `true` if this Collapsible is currently expanding.
  #
  # @member {boolean} expanding
  # @memberof stout-ui/traits/HasCollapsibleStates#
  ###
  @property 'expanding',
    type: 'boolean'
    default: false
