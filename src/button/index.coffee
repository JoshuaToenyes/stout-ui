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

  view = new ButtonView init

  # Configure event proxying.
  init.context.proxyEvents view, 'blur focus active hover click leave'

  view.context
