###*
# @overview Registers the custom pane tag and defines the pane factory.
#
# @module stout-ui/pane
###
defaults = require 'lodash/defaults'
Pane     = require './Pane'
PaneView = require './PaneView'
parser   = require 'stout-client/parser'

# Read the button custom HTML tag.
TAG_NAME = vars.readPrefixed 'pane/pane-tag'

# Register the button tag.
parser.register TAG_NAME, ButtonView, Button, {contentsMember: 'label'}

module.exports = (init) ->
  defaults init, {context: new PaneView}

  view = new PaneView init

  view.context
