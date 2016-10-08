###*
# @overview Defines the view class for a drawer component.
#
# @module stout-ui/drawer/DrawerView
###
debouce  = require 'lodash/debounce'
defaults = require 'lodash/defaults'
Drawer   = require './Drawer'
isString = require 'lodash/isString'
nextTick = require 'stout-client/util/nextTick'
PaneView = require '../pane/PaneView'
prefix   = require 'stout-client/util/prefix'
Promise  = require 'stout-core/promise/Promise'
vars     = require '../vars'

# Load drawer variables.
require '../vars/drawer'


###*
# The class to add to the drawer root element.
#
# @const {string}
# @private
###
DRAWER_CLS = vars.read 'drawer/drawer-class'


###*
# The class added to the drawer when it's locked open.
#
# @const {string}
# @private
###
DRAWER_LOCKED_CLS = vars.read 'drawer/drawer-locked-class'


###*
# Class name to add to the drawer's target element for transitions.
#
# @const {string}
# @private
###
DRAWER_TARGET_CLS = vars.readPrefixed 'drawer/drawer-target-class'


###*
# Class name to add to the drawer's container element.
#
# @const {string}
# @private
###
DRAWER_CONTAINER_CLS = vars.readPrefixed 'drawer/drawer-container-class'


###*
# Class name to add to the drawer's viewport element to contain screen overflow.
#
# @const {string}
# @private
###
DRAWER_VIEWPORT_CLS = vars.readPrefixed 'drawer/drawer-viewport-class'


DRAWER_P_OPEN_CLS = vars.readPrefixed 'drawer/drawer-target-open-class'
DRAWER_P_CLOSED_CLS = vars.readPrefixed 'drawer/drawer-target-closed-class'
DRAWER_P_OPENING_CLS = vars.readPrefixed 'drawer/drawer-target-opening-class'
DRAWER_P_CLOSING_CLS = vars.readPrefixed 'drawer/drawer-target-closing-class'


###*
# The debounce time for window resizes to trigger drawer open/close.
#
# @const {number}
# @private
###
RESIZE_DEBOUNCE = 100


###*
# List of properties cloned and synced between the view and view-model.
#
# @const {string}
# @private
###
SYNCED_PROPS = 'maxHeight maxWidth minHeight minWidth behavior side locked'


###*
# The drawer custom tag name.
#
# @const {string}
# @private
###
TAG_NAME = vars.readPrefixed 'drawer/drawer-tag'


###*
# Helper to grab matching string query selectors, if a string is specified.
#
# @function selectorHelper
# @inner
###
selectorHelper = (v) ->
  if isString v
    els = document.querySelector(v)
    if els is null
      null
    else if els.length and els.length > 0
      els[0]
    else
      els
  else
    v



###*
# The ModalView class is the view portion of a generic modal container.
#
# @param {Object} [init] - Initiation object.
#
# @exports stout-ui/drawer/DrawerView
# @extends stout-ui/pane/PaneView
# @constructor
###
module.exports = class DrawerView extends PaneView

  constructor: (init, events) ->
    defaults init, {tagName: TAG_NAME}
    super arguments...

    # Don't immediately show the view.
    @options.showOnRender = false

    @syncProperty @context, SYNCED_PROPS, inherit: 'falsy'

    @prefixedClasses.add DRAWER_CLS
    @prefixedClasses.add 'behavior-' + @behavior

    # Handle "side" changes
    for s in 'side container target viewport'.split /\s+/
      @stream s, @_setupDrawer, @

    debouncedLock = debouce =>
      @_lockDrawer()
    , RESIZE_DEBOUNCE

    @addEventListenerTo window, 'resize', debouncedLock

    # Attach to view-model event signals.
    @context.on 'open', @open, @
    @context.on 'close', @close, @
    @context.on 'toggle', @toggle, @

    @on 'transition', @_offsetTarget, @

  @cloneProperty Drawer, SYNCED_PROPS


  ###*
  # The container element for "push" behavior.
  #
  # @member container
  # @memberof stout-ui/drawer/DrawerView#
  ###
  @property 'container',
    set: selectorHelper
    get: (v) -> v or @parentEl


  ###*
  # The target content element which is offset by the drawer.
  #
  # @member target
  # @memberof stout-ui/drawer/DrawerView#
  ###
  @property 'target',
    set: selectorHelper
    get: (v) -> v or @root.nextElementSibling


  ###*
  # The viewport container element for "push" behavior.
  #
  # @member viewport
  # @memberof stout-ui/drawer/DrawerView#
  ###
  @property 'viewport',
    set: selectorHelper
    get: (v) -> v or @container.parentElement


  ###*
  # Checks if the window is of the minimum size for locking-open the drawer.
  # This method will open or close the drawer as appropriate.
  #
  # @method _lockDrawer
  # @memberof stout-ui/drawer/DrawerView#
  # @private
  ###
  _lockDrawer: ->
    W = window.innerWidth
    H = window.innerHeight

    # If the window is of the minimum size, then lock open or close the drawer.
    if (@minWidth >= 0 and W >= @minWidth) or
    (@minHeight >= 0 and H >= @minHeight) or
    (@maxWidth >= 0 and W < @maxWidth) or
    (@maxHeight >= 0 and H < @maxHeight)
      @prefixedClasses.add DRAWER_LOCKED_CLS
      @locked = true
      if @hidden
        @open()
      else
        @_offsetTarget(false)

    # If the drawer was previously locked open, and we've decresed the window
    # size, or the size of the viewport has increased past the maximum width
    # or height, then close the drawer.
    else if @locked
      @locked = false
      @close().then =>
        @prefixedClasses.remove DRAWER_LOCKED_CLS

    else
      @prefixedClasses.remove DRAWER_LOCKED_CLS
      @locked = false

    # if @locked
    #   @transition = 'overlay'
    # else if @behavior is 'push'
    #   @transition = 'fade'


  _setElementClasses: (state) ->
    remove = [
      DRAWER_P_OPEN_CLS
      DRAWER_P_CLOSED_CLS
      DRAWER_P_OPENING_CLS
      DRAWER_P_CLOSING_CLS]
    @target.classList.remove(c) for c in remove
    @container.classList.remove(c) for c in remove
    switch state
      when 'open' then add = DRAWER_P_OPEN_CLS
      when 'closed' then add = DRAWER_P_CLOSED_CLS
      when 'opening' then add = DRAWER_P_OPENING_CLS
      when 'closing' then add = DRAWER_P_CLOSING_CLS
    @target.classList.add add
    @container.classList.add add


  ###*
  # Increase the max listener count prior to traits being initialized.
  #
  # @method _preTraitInit
  # @memberof stout-ui/drawer/DrawerView#
  # @private
  ###
  _preTraitInit: ->
    @maxListenerCount 'change', 30


  ###*
  # Offsets the drawer target (corresponding content container). Depending on
  # the drawer behavior (overlay or push), the target's padding or transform
  # is adjusted.
  #
  # @method _offsetTarget
  # @memberof stout-ui/drawer/DrawerView#
  # @private
  ###
  _offsetTarget: ->
    if @transitioningOut
      size = 0
    else
      computedStyle = getComputedStyle @root
      cs = {}
      cs[k] = parseInt(computedStyle[k]) for k in [
        'width'
        'height'
        'paddingLeft'
        'paddingRight'
        'paddingTop'
        'paddingBottom'
      ]

      if @side in ['left', 'right']
        size = cs.width + cs.paddingLeft + cs.paddingRight
      else
        size = cs.height + cs.paddingTop + cs.paddingBottom

      # Invert size for negative translation.
      if @behavior is 'push' and @side in ['right', 'bottom']
        size = -size

    if @side in ['top', 'bottom']
      #translateFunc = 'translateY'
      translateFunc = 'top'
    else
      #translateFunc = 'translateX'
      translateFunc = 'left'

    switch @side
      when 'top' then oppositeSide = 'bottom'
      when 'right' then oppositeSide = 'left'
      when 'bottom' then oppositeSide = 'top'
      when 'left' then oppositeSide = 'right'

    # Handle moving the appropriate containers.
    if @behavior is 'push'
      # t = if @transitioningOut then 'none' else "#{translateFunc}(#{size}px)"
      # prefix @container, 'transform', t
      t = if @transitioningOut then '0' else "#{size}px"
      @container.style[translateFunc] = t

      if @locked
        @target.style["padding-#{oppositeSide}"] = size + 'px'
      else
        @target.style["padding-#{oppositeSide}"] = '0'

    else
      @target.style["padding-#{@side}"] = size + 'px'


  ###*
  # Updates the size and position of the drawer based on configured "size"
  # property.
  #
  # @method _setupDrawer
  # @memberof stout-ui/drawer/DrawerView#
  # @private
  ###
  _setupDrawer: ->
    # Reset all side positioning.
    @root.style[s] = 'auto' for s in ['top', 'right', 'bottom', 'left']

    # Set the width and height based on the configured "side" where the drawer
    # should open. Drawer sizing should be adjusted by modifying the content.
    if @side in ['left', 'right']
      @height = 'full'
      @width = 'auto'
      @root.style.top = '0'
    else
      @height = 'auto'
      @width = 'full'
      @root.style.left = '0'

    # Stick the drawer to the specified side.
    #@root.style[@side] = '0'

    # Initially position off-screen.
    @root.style[@side] = '-1000px'
    @container.style[@side] = '0'

    # The drawer should slide in and out from the side it's attached to.
    @start = @end = @side

    # Set the pane transition type.
    if @behavior is 'push'
      @transition = 'fade'
      @getRenderedDimensions().then (d) =>
        @root.style.left = "-#{width}px"
    else
      @transition = 'overlay'

    # Set initial classes.
    @target.classList.add DRAWER_TARGET_CLS

    if @behavior is 'push'
      @container.classList.add DRAWER_CONTAINER_CLS
      @viewport.classList.add DRAWER_VIEWPORT_CLS
    else
      @container.classList.remove DRAWER_CONTAINER_CLS
      @viewport.classList.remove DRAWER_VIEWPORT_CLS

    return


  setDisplaySize: ->
    super().then ({width, height}) =>
      @root.style.left = '0'


  ###*
  # Closes the drawer.
  #
  # @method close
  # @memberof stout-ui/drawer/DrawerView#
  ###
  close: =>
    if @canTransitionOut()
      @_setElementClasses 'closing'
      @contents.getRenderedDimensions().then ({width, height}) =>
        @root.style.left = "-#{width}px"
        @transitionOut().then => @_setElementClasses 'closed'
    else
      Promise.rejected()


  ###*
  # Opens the drawer.
  #
  # @method open
  # @memberof stout-ui/drawer/DrawerView#
  ###
  open: =>
    if @canTransitionIn()
      @_setElementClasses 'opening'
      #@_setupDrawer().then =>
      @transitionIn().then => @_setElementClasses 'open'
    else
      Promise.rejected()


  ###*
  # Renders this drawer component. After all ancestor rendering is complete,
  # the component then checks if it should be locked-open.
  #
  # @method render
  # @memberof stout-ui/drawer/DrawerView#
  ###
  render: ->
    super().then =>
      @_setupDrawer()
      @contents.getRenderedDimensions().then ({width, height}) =>
        @root.style.left = "-#{width}px"
        @_lockDrawer()
        @prefixedClasses.add 'ready'


  ###*
  # Toggles the drawer open/closed.
  #
  # @method toggle
  # @memberof stout-ui/drawer/DrawerView#
  ###
  toggle: =>
    if @visible then @close() else @open()
