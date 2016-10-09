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

transitions = require './transition'

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
SYNCED_PROPS = 'maxHeight maxWidth minHeight minWidth side locked transition'


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

  constructor: (init, events = []) ->
    events = events.concat ['opening', 'open', 'closing', 'close', 'toggle']
    init = defaults init, {tagName: TAG_NAME}
    super init, events

    @_transitions = transitions

    # Don't immediately show the view.
    @options.showOnRender = false

    @syncProperty @context, SYNCED_PROPS, inherit: 'falsy'

    @prefixedClasses.add DRAWER_CLS
    @prefixedClasses.add 'transition-' + @transition

    # Attach to view-model event signals.
    @context.on 'open', @open, @
    @context.on 'close', @close, @
    @context.on 'toggle', @toggle, @

  @cloneProperty Drawer, SYNCED_PROPS


  ###*
  # Set of transition utilities for positioning and sizing the drawer and
  # drawer target.
  #
  # @member _transitions
  # @memberof stout-ui/drawer/DrawerView#
  # @protected
  # @override
  ###


  ###*
  # The container element for "push" transition.
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
  # The viewport container element for "push" transition.
  #
  # @member viewport
  # @memberof stout-ui/drawer/DrawerView#
  ###
  @property 'viewport',
    set: selectorHelper
    get: (v) -> v or @container.parentElement


  ###*
  # Sets classes on drawer-related elements based on its state.
  #
  # @method _setDrawerStateClasses
  # @memberof stout-ui/drawer/DrawerView#
  # @protected
  ###
  _setDrawerStateClasses: (state) ->
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
  # Closes the drawer.
  #
  # @method close
  # @memberof stout-ui/drawer/DrawerView#
  ###
  close: =>
    if @canTransitionOut()
      @transitionOut().then =>
        @_transitions[@transition].afterOut.call @
        @_setDrawerStateClasses 'closed'
        @fire 'close'
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
      @transitionIn().then =>
        @_transitions[@transition].afterIn.call @
        @_setDrawerStateClasses 'open'
        @fire 'open'
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
      @target.classList.add DRAWER_TARGET_CLS
      @container.classList.add DRAWER_CONTAINER_CLS
      @viewport.classList.add DRAWER_VIEWPORT_CLS


  ###*
  # Toggles the drawer open/closed.
  #
  # @method toggle
  # @memberof stout-ui/drawer/DrawerView#
  ###
  toggle: =>
    @fire 'toggle'
    if @visible then @close() else @open()
