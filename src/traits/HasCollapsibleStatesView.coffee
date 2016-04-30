###*
# @overview Defines the `HasCollapsibleStatesView` trait which may be used
# to add common collapsible traits and methods to a component's view.
#
# @module stout-ui/traits/HasCollapsibleStatesView
###
Foundation           = require 'stout-core/base/Foundation'
HasCollapsibleStates = require './HasCollapsibleStates'
vars                 = require '../vars'

# Require shared input variables.
require '../vars/collapsible'


###*
# Class indicating that the item is currently collapsed.
#
# @type {string}
# @const
###
COLLAPSED_CLS = vars.read 'collapsible/collapsible-collapsed-class'


###*
# Class added to the tree during a collapsing transition.
#
# @type {string}
# @const
###
COLLAPSING_CLS = vars.read 'collapsible/collapsible-collapsing-class'


###*
# Class indicating that the item is currently expanded.
#
# @type {string}
# @const
###
EXPANDED_CLS = vars.read 'collapsible/collapsible-expanded-class'


###*
# Class added to the tree during an expand transition.
#
# @type {string}
# @const
###
EXPANDING_CLS = vars.read 'collapsible/collapsible-expanding-class'



###*
# The `HasCollapsibleStatesView` trait adds collapsible states and common
# methods to views which are collapsible, are collapsible triggers, or are
# otherwise related to collapsible components.
#
# @exports stout-ui/traits/HasCollapsibleStatesView
# @mixin
###
module.exports = class HasCollapsibleStatesView extends Foundation

  @useTrait HasCollapsibleStates


  ###*
  # Sets the collpasible state of this component view.
  #
  # @method _setCollapsingState
  # @memberof stout-ui/traits/HasCollapsibleStatesView#
  ###
  _setCollapsingState: (state) ->
    @[s] = false for s in ['collapsing', 'expanding', 'collapsed', 'expanded']
    switch state
      when 'collapsing'
        @collapsing = true
        add = COLLAPSING_CLS
      when 'expanding'
        @expanding = true
        add = EXPANDING_CLS
      when 'collapsed'
        @collapsed = true
        add = COLLAPSED_CLS
      when 'expanded'
        @expanded = true
        add = EXPANDED_CLS
    @prefixedClasses.remove COLLAPSING_CLS, COLLAPSED_CLS,
    EXPANDING_CLS, EXPANDED_CLS
    @prefixedClasses.add add
