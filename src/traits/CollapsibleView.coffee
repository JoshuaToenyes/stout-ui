###*
# @overview Defines the `CollapsibleView` trait which describes a view capable
# of collapsing and expanding, like an accordion or tree.
#
# @module stout-ui/traits/CollapsibleView
###
Collapsible = require './Collapsible'
Foundation  = require 'stout-core/base/Foundation'
HasCollapsibleStatesView = require './HasCollapsibleStatesView'
Promise     = require 'stout-core/promise/Promise'
vars        = require '../vars'

# Require shared input variables.
require '../vars/component'
require '../vars/collapsible'


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
# Collapsible class added to items which should be rendered as "collapsible."
#
# @type {string}
# @const
###
COLLAPSIBLE = vars.readPrefixed 'collapsible/collapsible-class'


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
# The `CollapsibleView` trait can be added to a component to make it collapsible
# like an accordion or tree view.
#
# @exports stout-ui/traits/CollapsibleView
# @mixin
###
module.exports = class CollapsibleView extends Foundation

  @useTrait HasCollapsibleStatesView


  ###*
  # Height-setting timer.
  #
  # @member _heightSettingTimer
  # @memberof stout-ui/traits/CollapsibleView#
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
  # Initiates this trait by adding the appropriate collapsible classes.
  #
  # @method initTrait
  # @memberof stout-ui/traits/CollapsibleTriggerView#
  # @private
  ###
  initTrait: ->
    @classes.add COLLAPSIBLE


  ###*
  # Collapses this `CollapsibleView`.
  #
  # @param {boolean} now - Set to `true` to immediately collapse without
  # animation.
  #
  # @method collapse
  # @memberof stout-ui/traits/CollapsibleView#
  ###
  collapse: (now = false) ->
    if now then now = 0 else now = 1

    @_setCollapsingState 'collapsing'

    @getRenderedDimensions(null, ['height']).then (d) =>
      i = 0
      promises = []

      @root.style.height = d.height + 'px'
      @repaint()

      # Transition out all children items in a ripple-like fashion.
      @_getCollapsibleChildren().reverse().every (item) ->
        delay = now * ++i * CHILD_OFFSET_T
        promises.push item.transitionOut(now * CHILD_TRANS_OUT_T, delay)

      # Transition out this tree.
      promises.push @transitionOut(now * COLLAPSE_T, now * CHILD_TRANS_OUT_T)

      clearTimeout @_heightSettingTimer
      @_heightSettingTimer = setTimeout =>
        @root.style.height = '0'
      , now * CHILD_TRANS_OUT_T

      # Return a promise that resolves when the tree and all its children are
      # collapsed and its height is set to zero.
      Promise.all(promises).then => @_setCollapsingState 'collapsed'


  ###*
  # Expands this `CollapsibleView`.
  #
  # @param {boolean} now - Set to `true` to immediately expand without
  # animation.
  #
  # @method expands
  # @memberof stout-ui/traits/CollapsibleView#
  ###
  expand: (now = false) ->
    if now then now = 0 else now = 1

    clearTimeout @_heightSettingTimer
    @_setCollapsingState 'expanding'

    # Calculate the rendered height of this tree.
    @getRenderedDimensions(null, ['height']).then (d) =>
      i = 0
      promises = []

      @once 'transition:in', =>
        @root.style.height = d.height + 'px'

      # Transition-in all children.
      @_getCollapsibleChildren().every (item) ->
        delay = ++i * CHILD_OFFSET_T + CHILD_TRANS_IN_T / 2
        promises.push item.transitionIn(now * CHILD_TRANS_IN_T, now * delay)

      promises.push @transitionIn(now * EXPAND_T)

      Promise.all(promises).then =>
        @_setCollapsingState 'expanded'
        @root.style.height = 'auto'


  ###*
  # Toggles the collapse-state of this `CollapsibleView`.
  #
  # @method toggle
  # @memberof stout-ui/traits/CollapsibleView#
  ###
  toggle: ->
    if @collapsed
      @expand()
    else if @expanded
      @collapse()
