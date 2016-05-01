###*
# @overview Defines the view class for a drawer component.
#
# @module stout-ui/drawer/DrawerView
###
debouce  = require 'lodash/debounce'
defaults = require 'lodash/defaults'
Drawer   = require './Drawer'
nextTick = require 'stout-client/util/nextTick'
PaneView = require '../pane/PaneView'
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
# Class name to add to the drawer's parent element for transitions.
#
# @const {string}
# @private
###
DRAWER_PARENT_CLS = vars.readPrefixed 'drawer/drawer-parent-class'


DRAWER_P_OPEN_CLS = vars.readPrefixed 'drawer/drawer-parent-open-class'
DRAWER_P_CLOSED_CLS = vars.readPrefixed 'drawer/drawer-parent-closed-class'
DRAWER_P_OPENING_CLS = vars.readPrefixed 'drawer/drawer-parent-opening-class'
DRAWER_P_CLOSING_CLS = vars.readPrefixed 'drawer/drawer-parent-closing-class'


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
SYNCED_PROPS = 'minWidth minHeight openBehavior side'


###*
# The drawer custom tag name.
#
# @const {string}
# @private
###
TAG_NAME = vars.readPrefixed 'drawer/drawer-tag'



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

    @syncProperty @context, SYNCED_PROPS

    # Set the pane transition type.
    @transition = 'overlay'

    @prefixedClasses.add DRAWER_CLS

    # Handle "side" changes
    @stream 'side', @_updateSizeAndPosition, @
    @_updateSizeAndPosition()

    debouncedLock = debouce =>
      @_lockDrawer()
    , RESIZE_DEBOUNCE

    @addEventListenerTo window, 'resize', debouncedLock

    # Attach to view-model event signals.
    @context.on 'open', @open, @
    @context.on 'close', @close, @

    @on 'transition:in', => @_setParentPadding(false)
    @on 'transition:out', => @_setParentPadding(true)

  @cloneProperty Drawer, SYNCED_PROPS


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
    if W >= @minWidth and H >= @minHeight
      @prefixedClasses.add DRAWER_LOCKED_CLS
      @open()
    else
      @close().then =>
        @prefixedClasses.remove DRAWER_LOCKED_CLS


  _setParentState: (state) ->
    remove = [
      DRAWER_P_OPEN_CLS
      DRAWER_P_CLOSED_CLS
      DRAWER_P_OPENING_CLS
      DRAWER_P_CLOSING_CLS]
    @parentEl.classList.remove(c) for c in remove
    switch state
      when 'open' then add = DRAWER_P_OPEN_CLS
      when 'closed' then add = DRAWER_P_CLOSED_CLS
      when 'opening' then add = DRAWER_P_OPENING_CLS
      when 'closing' then add = DRAWER_P_CLOSING_CLS
    @parentEl.classList.add add


  _setParentPadding: (close) ->
    prop = "padding-#{@side}"
    if close
      size = 0
    else
      if @side in ['left', 'right']
        size = @root.style.width
      else
        size = @root.style.height
      size = parseInt size
    @parentEl.style[prop] = size + 'px'


  ###*
  # Updates the size and position of the drawer based on configured "size"
  # property.
  #
  # @method _updateSizeAndPosition
  # @memberof stout-ui/drawer/DrawerView#
  # @private
  ###
  _updateSizeAndPosition: ->
    # Set the width and height based on the configured "side" where the drawer
    # should open. Drawer sizing should be adjusted by modifying the content.
    if @side in ['left', 'right']
      @height = 'full'
      @width = 'auto'
    else
      @height = 'auto'
      @width = 'full'

    # The drawer should slide in and out from the side it's attached to.
    @start = @end = @side


  ###*
  # Closes the drawer.
  #
  # @method close
  # @memberof stout-ui/drawer/DrawerView#
  ###
  close: =>
    if @canTransitionOut()
      @_setParentState 'closing'
      @transitionOut().then => @_setParentState 'closed'
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
      @_setParentState 'opening'
      @transitionIn().then => @_setParentState 'open'
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
      @parentEl.className += ' ' + DRAWER_PARENT_CLS
      @_lockDrawer()
