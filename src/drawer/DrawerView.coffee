###*
# @overview Defines the view class for a drawer component.
#
# @module stout-ui/drawer/DrawerView
###
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
# Class name to add to the drawer's parent element for transitions.
#
# @const {string}
# @private
###
DRAWER_PARENT_CLS = vars.readPrefixed 'drawer/drawer-parent-class'


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

    @addEventListenerTo window, 'resize', @_lockDrawer, @

    # Attach to view-model event signals.
    @context.on 'open', @open, @
    @context.on 'close', @close, @

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
      @open()
    else
      @close()


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
  close: => if @visible and not @transitioning then @transitionOut()


  ###*
  # Opens the drawer.
  #
  # @method open
  # @memberof stout-ui/drawer/DrawerView#
  ###
  open: => if not @visible and not @transitioning then @transitionIn()


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
