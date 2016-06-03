###*
# @overview Defines the `PopupView` class, the view portion of a Popup
# component.
#
# @module stout-ui/popup/PopupView
###
Affixable       = require '../traits/Affixable'
defaults        = require 'lodash/defaults'
InteractiveView = require '../interactive/InteractiveView'
vars            = require '../vars'

# Require shared variables.
require '../vars/popup'


###*
# The popup custom tag name.
#
# @type string
# @const
# @private
###
TAG_NAME = vars.readPrefixed 'popup/popup-tag'


###*
# The popup class name.
#
# @type string
# @const
# @private
###
POPUP_CLASS = vars.read 'popup/popup-class'



###*
# The PopupView is a component which "pops-up" over some parent element.
#
# @exports stout-ui/popup/PopupView
# @extends stout-ui/interactive/InteractiveView
# @constructor
###
module.exports = class PopupView extends InteractiveView

  @useTrait Affixable

  constructor: (init, events) ->
    defaults init, {tagName: TAG_NAME}
    super init, events

    @options.showOnRender = false

    @prefixedClasses.add POPUP_CLASS
