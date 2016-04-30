###*
# @overview Defines the `CollapsibleTriggerView` trait which describes a
# component which expands and contracts one or more corresponding
# `CollapsibleView` components.
#
# @module stout-ui/traits/CollapsibleTriggerView
###
Collapsible              = require './Collapsible'
CollapsibleView          = require './CollapsibleView'
Foundation               = require 'stout-core/base/Foundation'
HasCollapsibleStatesView = require './HasCollapsibleStatesView'
NotImplementedErr        = require('stout-core/err').NotImplementedErr
Promise                  = require 'stout-core/promise/Promise'
vars                     = require '../vars'

# Require shared input variables.
require '../vars/component'
require '../vars/collapsible'


###*
# Collapsible class added to items which should be rendered as "collapsible."
#
# @type {string}
# @const
###
COLLAPSIBLE = vars.read 'collapsible/collapsible-class'


###*
# Class indicating that the item is currently collapsed.
#
# @type {string}
# @const
###
COLLAPSED_CLS = vars.read 'collapsible/collapsible-collapsed-class'


###*
# Class indicating that the item is currently expanded.
#
# @type {string}
# @const
###
EXPANDED_CLS = vars.read 'collapsible/collapsible-expanded-class'


###*
# Collapsible trigger class added to items which are collapsible triggers.
#
# @type {string}
# @const
###
TRIGGER_CLS = vars.readPrefixed 'collapsible/collapsible-trigger-class'



###*
# The `CollapsibleTriggerView` view class is the view portion of a component
# which can trigger the collapse/expansion of another `CollapsibleView`.
#
# @exports stout-ui/traits/CollapsibleTriggerView
# @mixin
###
module.exports = class CollapsibleTriggerView extends Foundation

  @useTrait HasCollapsibleStatesView

  ###*
  # Initiates this trait by adding the appropriate classes and event listeners.
  #
  # @method initTrait
  # @memberof stout-ui/traits/CollapsibleTriggerView#
  # @private
  ###
  initTrait: ->
    @classes.add TRIGGER_CLS

    @on 'ready', @_onCollapsibleReady, @

    # Listen for touchstart/mouseup events to toggle the tree.
    @on 'mouseup', (e) =>
      e.data.stopPropagation()
      @toggle()


  ###*
  # Collapses child CollapsibleView's and their descendants. This method
  # doesn't do any checking to determine if a collpase should be "allowed" or
  # not.
  #
  # @param {boolean} now - Set to `true` to immediately collapse without
  # animation.
  #
  # @method _collapse
  # @memberof stout-ui/traits/CollapsibleTriggerView#
  # @private
  ###
  _collapse: (now) ->
    children = @children.get(CollapsibleView)
    if children.length > 0
      @_setCollapsingState 'collapsing'
      children.every (collapsible) =>
        collapsible.collapse(now).then =>
          @_setCollapsingState 'collapsed'


  ###*
  # Expands child CollapsibleView's and their descendants. This method doesn't
  # do any checking to determine if an expand should be "allowed" or not.
  #
  # @param {boolean} now - Set to `true` to immediately expand without
  # animation.
  #
  # @method _expand
  # @memberof stout-ui/traits/CollapsibleTriggerView#
  ###
  _expand: (now) ->
    children = @children.get(CollapsibleView)
    if children.length > 0
      @_setCollapsingState 'expanding'
      children.every (collapsible) =>
        collapsible.expand(now).then =>
          @_setCollapsingState 'expanded'


  ###*
  # Updates the "collapsible" display state of this item on-ready.
  #
  # @method _onCollapsibleReady
  # @memberof stout-ui/traits/CollapsibleTriggerView#
  # @private
  ###
  _onCollapsibleReady: ->
    if @children.get(CollapsibleView).length > 0 and @collapsible
      if @collapsed
        @_collapse(true)
      else
        @prefixedClasses.add EXPANDED_CLS
      @prefixedClasses.add COLLAPSIBLE
    if @collapsed and @collapsible
      @prefixedClasses.add COLLAPSED_CLS


  ###*
  # Closes the child CollapsibleView's of this Collapsible trigger item, if
  # it is currently expand and is collapsible.
  #
  # @method collapse
  # @memberof stout-ui/traits/CollapsibleTriggerView#
  ###
  collapse: ->
    if @collapsible and @expanded
      @_collapse()
    else
      Promise.fulfilled()


  ###*
  # Opens the child CollapsibleView's of this Collapsible trigger item, if it
  # is currently collapsed and is collapsible.
  #
  # @method expand
  # @memberof stout-ui/traits/CollapsibleTriggerView#
  ###
  expand: ->
    if @collapsible and @collapsed
      @_expand()
    else
      Promise.fulfilled()


  ###*
  # Toggles the expanded/collapsed state of this Collapsible.
  #
  # @method toggle
  # @memberof stout-ui/traits/CollapsibleTriggerView#
  ###
  toggle: ->
    if @collapsed then @expand() else @collapse()
