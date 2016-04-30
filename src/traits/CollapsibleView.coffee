###*
# @overview Defines the `CollapsibleView` trait which describes a view capable
# of collapsing and expanding, like an accordion or tree.
#
# @module stout-ui/traits/CollapsibleView
###
Collapsible = require './Collapsible'
Foundation  = require 'stout-core/base/Foundation'
Promise     = require 'stout-core/promise/Promise'
vars        = require '../vars'

# Require shared input variables.
require '../vars/collapsible'


###*
# The time (in millseconds) a collapse operation should take.
#
# @type {number}
# @const
###
COLLAPSE_T = vars.readTime 'collapsible/collapsible-collapse-time'


###*
# The time (in millseconds) an expand operation should take.
#
# @type {number}
# @const
###
EXPAND_T = vars.readTime 'collapsible/collapsible-expand-time'


###*
# The default time (in millseconds) to offset each child transition-in.
#
# @type {number}
# @const
###
CHILD_OFFSET_T = vars.readTime 'collapsible/collapsible-child-offset-time'


###*
# The default time (in millseconds) a child transition-in should take.
#
# @type {number}
# @const
###
CHILD_TRANS_IN_T = vars.readTime 'collapsible/collapsible-child-trans-in-time'


###*
# The default time (in millseconds) a child transition-out should take.
#
# @type {number}
# @const
###
CHILD_TRANS_OUT_T = vars.readTime 'collapsible/collapsible-child-trans-out-time'



###*
#
#
# @exports stout-ui/traits/CollapsibleView
# @mixin
###
module.exports = class CollapsibleView extends Foundation

  ###*
  # Height-setting timer.
  #
  # @member _heightSettingTimer
  # @memberof stout-ui/traits/CollapsibleView
  # @private
  ###


  ###*
  # Returns set of collapsible children which should be transitioned-in. This
  # method can be overridden to provide more advanced functionality.
  #
  # @method _getCollapsibleChildren
  # @memberof stout-ui/traits/CollapsibleView#
  ###
  _getCollapsibleChildren: ->
    @children.get('*')


  ###*
  # Collapses this `CollapsibleView`.
  #
  # @method collapse
  # @memberof stout-ui/traits/CollapsibleView#
  ###
  collapse: ->
    i = 0
    promises = []

    @getRenderedDimensions(null, ['height']).then (d) =>

      @root.style.height = d.height + 'px'
      @repaint()

      # Transition out all children items in a ripple-like fashion.
      @_getCollapsibleChildren().reverse().every (item) ->
        delay = ++i * CHILD_OFFSET_T
        promises.push item.transitionOut(CHILD_TRANS_OUT_T, delay)

      # Transition out this tree.
      promises.push @transitionOut(COLLAPSE_T, CHILD_TRANS_OUT_T)

      clearTimeout @_heightSettingTimer
      @_heightSettingTimer = setTimeout =>
        @root.style.height = '0'
      , CHILD_TRANS_OUT_T

      # Return a promise that resolves when the tree and all its children are
      # collapsed and its height is set to zero.
      Promise.all(promises)


  ###*
  # Expands this `CollapsibleView`.
  #
  # @method expands
  # @memberof stout-ui/traits/CollapsibleView#
  ###
  expand: ->
    # Clear existing collapsing timer.
    clearTimeout @_heightSettingTimer

    # Calculate the rendered height of this tree.
    @getRenderedDimensions(null, ['height']).then (d) =>
      i = 0
      promises = []

      @once 'transition:in', =>
        @root.style.height = d.height + 'px'

      # Transition-in all children.
      @_getCollapsibleChildren().every (item) ->
        delay = ++i * CHILD_OFFSET_T + CHILD_TRANS_IN_T / 2
        promises.push item.transitionIn(CHILD_TRANS_IN_T, delay)

      promises.push @transitionIn(EXPAND_T)

      Promise.all(promises).then =>
        @root.style.height = 'auto'


  toggle: -> #TODO
