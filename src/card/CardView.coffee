###*
# @overview Defines the `CardView` view class.
#
# @module stout-ui/card/CardView
###
defaults              = require 'lodash/defaults'
InteractiveView       = require '../interactive/InteractiveView'
Promise               = require 'stout-core/promise/Promise'
template              = require './card.template'
TransitionCanceledExc = require('stout-client/exc').TransitionCanceledExc
vars                  = require '../vars'

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


CARD_CLASS = vars.read 'card/card-class'
FLIPPABLE_CLASS = vars.read 'card/card-flippable-class'
FLIPPED_CLASS = vars.read 'card/card-flipped-class'
FLIPPING_CLASS = vars.read 'card/card-flipping-class'
FLIP_TIME = vars.readTime 'card/card-flip-time'


onCardReady = ->
  if @select('.ui-card-back')
    @context.flippable = true
    @prefixedClasses.add FLIPPABLE_CLASS


onFlipping = (e) ->
  fn = if e.data.value then 'add' else 'remove'
  @prefixedClasses[fn] FLIPPING_CLASS



onFlip = (e) ->
  fn = if e.data.value then 'add' else 'remove'
  @prefixedClasses[fn] FLIPPED_CLASS


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
    @prefixedClasses.add CARD_CLASS

    @on 'ready', onCardReady

    @context.on 'change:flipping', onFlipping, @
    @context.on 'change:flipped', onFlip, @


  flip: ->
    @context.flip()
