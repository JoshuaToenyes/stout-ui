###*
# @overview Registers the custom checkbox tag.
#
# @module stout-ui/radio
###
defaults        = require 'lodash/defaults'
RadioButton     = require './RadioButton'
RadioButtonView = require './RadioButtonView'
parser          = require 'stout-client/parser'

# Read the button custom HTML tag.
TAG_NAME = vars.readPrefixed 'radio-button/radio-button-tag'

# Register the button tag.
parser.register TAG_NAME, RadioButtonView, RadioButton

module.exports =

  factory: (init) ->
    defaults init, {context: new RadioButton}
    (new RadioButtonView init).context
