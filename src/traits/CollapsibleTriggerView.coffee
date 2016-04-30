###*
# @overview Defines the `CollapsibleTriggerView` trait which describes a
# component which expands and contracts one or more corresponding
# `CollapsibleView` components.
#
# @module stout-ui/traits/CollapsibleTriggerView
###
Collapsible       = require './Collapsible'
CollapsibleView   = require './CollapsibleView'
Foundation        = require 'stout-core/base/Foundation'
NotImplementedErr = require('stout-core/err').NotImplementedErr
vars              = require '../vars'

# Require shared input variables.
require '../vars/collapsible'


###*
# Collapsible class added to items which should be rendered as "collapsible."
#
# @type {string}
# @const
###
COLLAPSIBLE = vars.read 'collapsible/collapsible-collapsible-class'


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
#
#
# @exports stout-ui/traits/CollapsibleTriggerView
# @mixin
###
module.exports = class CollapsibleTriggerView extends Foundation

  @cloneProperty Collapsible, 'collapsible collapsed expanded
  expanding collapsing'


  ###*
  #
  #
  # @method initTrait
  # @memberof stout-ui/traits/CollapsibleTriggerView#
  # @private
  ###
  initTrait: ->
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
  # @method _collapse
  # @memberof stout-ui/traits/CollapsibleTriggerView#
  # @private
  ###
  _collapse: ->
    @prefixedClasses.remove EXPANDING_CLS
    @prefixedClasses.add COLLAPSING_CLS

    @children.get(CollapsibleView).every (collapsible) =>
      collapsible.collapse().then =>
        @collapsed = true
        @prefixedClasses.remove EXPANDING_CLS, COLLAPSING_CLS
        @prefixedClasses.add COLLAPSED_CLS


  ###*
  # Expands child CollapsibleView's and their descendants. This method doesn't
  # do any checking to determine if an expand should be "allowed" or not.
  #
  # @method _expand
  # @memberof stout-ui/traits/CollapsibleTriggerView#
  ###
  _expand: ->
    @prefixedClasses.remove COLLAPSED_CLS, COLLAPSING_CLS
    @prefixedClasses.add EXPANDING_CLS

    @children.get(CollapsibleView).every (collapsible) =>
      collapsible.expand().then =>
        @collapsed = false
        @prefixedClasses.remove EXPANDING_CLS, COLLAPSING_CLS


  ###*
  # Updates the "collapsible" display state of this item on-ready.
  #
  # @method _onCollapsibleReady
  # @memberof stout-ui/traits/CollapsibleTriggerView#
  # @private
  ###
  _onCollapsibleReady: ->

    @prefixedClasses.remove COLLAPSIBLE, COLLAPSED_CLS

    if @children.get(CollapsibleView).length > 0 and @collapsible
      if @collapsed then @_collapse()
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
    if @collapsible and not @collapsed
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
