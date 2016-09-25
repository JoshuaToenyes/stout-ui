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
  # Property allows the using class to sync it's collapsible state with it's
  # parent component. If set to `true` and this component's parent uses the
  # `HasCollapsibleStatesView` trait, it will set the parent's collapsible state
  # to match this element's state.
  #
  # @member setParentCollapsibleState
  # @memberof stout-ui/traits/HasCollapsibleStatesView#
  ###
  @property 'setParentCollapsibleState',
    default: false
    type: 'boolean'


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

    # Set the parent's collapsible state to match.
    if @setParentCollapsibleState and @parent and
    @parent.usingTrait(HasCollapsibleStatesView)
      @parent._setCollapsingState(state)
