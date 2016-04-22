###*
# @overview Defines the `CardView` view class.
#
# @module stout-ui/card/CardView
###
defaults        = require 'lodash/defaults'
InteractiveView = require '../interactive/InteractiveView'
template        = require './card.template'
vars            = require '../vars'

# Require shared input variables.
require '../vars/card'

###*
# The card custom tag name.
#
# @type string
# @const
# @private
###
TAG_NAME = vars.readPrefixed 'card/card-tag'



###*
# The `CardView` class represents the view of a single content card with
# generic content.
#
# @exports stout-ui/card/CardView
# @extends stout-ui/interactive/InteractiveView
# @constructor
###
module.exports = class CardView extends InteractiveView

  constructor: (init, events) ->
    defaults init, {template, tagName: TAG_NAME}
    super init, events
