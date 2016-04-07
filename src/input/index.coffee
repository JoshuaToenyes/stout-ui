###*
# @overview Registers the custom button tag.
#
# @module stout-ui/button
###
defaults   = require 'lodash/defaults'
Input      = require './Input'
InputView  = require './InputView'
parser     = require 'stout-client/parser'

# Read the button custom HTML tag.
TAG_NAME = vars.readPrefixed 'input/input-tag'

# Register the button tag.
parser.register TAG_NAME, InputView, Input, {contentsMember: 'label'}

module.exports = (init) ->

  factory: (init) ->
    defaults init, {context: new Input}
    (new InputView init).context
