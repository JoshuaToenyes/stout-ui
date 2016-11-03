###*
# @overview Defines the `Card` view-model class.
#
# @module stout-ui/card/Card
###
Interactive = require '../interactive/Interactive'
TransitionCanceledExc = require('stout-client/exc').TransitionCanceledExc
vars                  = require '../vars'

# Require shared input variables.
require '../vars/card'


FLIP_TIME = vars.readTime 'card/card-flip-time'


###*
# The `Card` class represents a single content card with generic content.
#
# @exports stout-ui/card/Card
# @extends stout-ui/interactive/Interactive
# @constructor
###
module.exports = Interactive.extend 'Card',

  constructor: ->
    Interactive.prototype.constructor.apply @, arguments
    return


  properties:

    'flippable':
      default: false

    'flipping':
      default: false

    'flipped':
      default: false

    'sideVisible':
      default: 'front'
      values: ['front', 'back']



  flip: ->
    new Promise (fulfill, reject) =>
      if not @flippable then reject(
        new TransitionCanceledExc "Card not flippable.")
      if @flipping then reject(
        new TransitionCanceledExc "Card currently flipping.")
      @flipped = not @flipped
      @flipping = true
      setTimeout =>
        @flipping = false
        fulfill()
      , FLIP_TIME
