###*
# @overview Registers the custom card tag.
#
# @module stout-ui/card
###
defaults = require 'lodash/defaults'
Card     = require './Card'
CardView = require './CardView'
parser   = require 'stout-client/parser'

# Read the button custom HTML tag.
TAG_NAME = vars.readPrefixed 'card/card-tag'

# Register the button tag.
parser.register TAG_NAME, CardView, Card

module.exports = (init) ->

  factory: (init) ->
    defaults init, {context: new Card}
    (new CardView init).context
