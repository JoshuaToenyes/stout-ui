###*
# @overview Defines the `DropdownView` class, the view class of the Dropdown
# component.
#
# @module stou-ui/dropdown/DropdownView
###
Affixable       = require '../traits/Affixable'
defaults        = require 'lodash/defaults'
InteractiveView = require '../interactive/InteractiveView'
vars            = require '../vars'

# Require dropdown shared variables.
require '../vars/dropdown'

###*
# The dropdown custom tag name.
#
# @type string
# @const
# @private
###
TAG_NAME = vars.readPrefixed 'dropdown/dropdown-tag'


###*
# The dropdown class name.
#
# @type string
# @const
# @private
###
DROPDOWN_CLASS = vars.read 'dropdown/dropdown-class'


###*
# Transition-in timing.
#
# @type string
# @const
# @private
###
DROPDOWN_TRANSITION_IN_T = vars.readTime 'dropdown/dropdown-transition-in-time'


###*
# Transition-out timing.
#
# @type string
# @const
# @private
###
DROPDOWN_TRANSITION_OUT_T = vars.readTime 'dropdown/dropdown-transition-out-time'


###*
#
#
#
###
module.exports = InteractiveView.extend 'DropdownView',

  traits: Affixable

  constructor: (init, events) ->
    init = defaults init,
      tagName: TAG_NAME
      affixPosition: 'bottom left'
      affixInside: 'x'
    InteractiveView.prototype.constructor.call @, init, events

    @prefixedClasses.add DROPDOWN_CLASS
    @options.showOnRender = false

    @__onBodyClick = (e) =>
      if @root.contains e.target then return
      @close()


  open: ->
    @transitionIn(DROPDOWN_TRANSITION_IN_T).then =>
      document.body.addEventListener 'click', @__onBodyClick


  close: ->
    @transitionOut(DROPDOWN_TRANSITION_OUT_T).then =>
      document.body.removeEventListener 'click', @__onBodyClick


  toggle: ->
    if @visible
      @close()
    else
      @open()
