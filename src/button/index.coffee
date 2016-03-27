###*
# @overview Registers the custom button tag.
#
# @module stout-ui/button
###
defaults   = require 'lodash/defaults'
Button     = require './Button'
ButtonView = require './ButtonView'
parser     = require 'stout-client/parser'

# Read the button custom HTML tag.
TAG_NAME = vars.readPrefixed 'button/button-tag'

# Register the button tag.
parser.register TAG_NAME, ButtonView, Button, {contentsMember: 'label'}

module.exports = (init) ->
  defaults init, {context: new Button}
  (new ButtonView init).context
