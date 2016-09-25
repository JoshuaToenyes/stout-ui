###*
# @overview Registers the custom checkbox tag.
#
# @module stout-ui/checkbox
###
defaults     = require 'lodash/defaults'
Checkbox     = require './Checkbox'
CheckboxView = require './CheckboxView'
parser       = require 'stout-client/parser'

# Read the button custom HTML tag.
TAG_NAME = vars.readPrefixed 'checkbox/checkbox-tag'

# Register the button tag.
parser.register TAG_NAME, CheckboxView, Checkbox, {contentsMember: 'label'}

module.exports = (init) ->
  defaults init, {context: new Checkbox}
  (new CheckboxView init).context
