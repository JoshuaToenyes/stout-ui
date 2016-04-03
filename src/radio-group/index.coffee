###*
# @overview Registers the custom checkbox tag.
#
# @module stout-ui/radio
###
defaults       = require 'lodash/defaults'
RadioGroup     = require './RadioGroup'
RadioGroupView = require './RadioGroupView'
parser         = require 'stout-client/parser'

# Read the button custom HTML tag.
TAG_NAME = vars.readPrefixed 'radio-group/radio-group-tag'

# Register the button tag.
parser.register TAG_NAME, RadioGroupView, RadioGroup

module.exports =

  factory: (init) ->
    defaults init, {context: new RadioGroup}
    (new RadioGroupView init).context
