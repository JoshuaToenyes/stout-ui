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

    @on 'ready', =>
      if @select('.ui-card-back')
        @flippable = true
        @prefixedClasses.add FLIPPABLE_CLASS


  @property 'flippable',
    default: false


  @property 'flipping',
    default: false


  @property 'flipped',
    default: false


  @property 'sideVisible',
    default: 'front'
    values: ['front', 'back']


  ###*
  # Flips the card, if it's flippable.
  #
  # @method flip
  # @memberof stout-ui/card/CardView
  ###
  flip: ->
    new Promise (fulfill, reject) =>
      if not @flippable then reject(
        new TransitionCanceledExc "Card not flippable.")
      if @flipping then reject(
        new TransitionCanceledExc "Card currently flipping.")
      @flipping = true
      @prefixedClasses.add FLIPPING_CLASS
      if @flipped
        @prefixedClasses.remove FLIPPED_CLASS
      else
        @prefixedClasses.add FLIPPED_CLASS
      setTimeout =>
        @prefixedClasses.remove FLIPPING_CLASS
        @flipping = false
        @flipped = not @flipped
        fulfill()
      , FLIP_TIME
