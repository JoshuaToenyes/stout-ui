###*
# @overview Registers the custom dropdown tag.
#
# @module stout-ui/dropdown
###
defaults     = require 'lodash/defaults'
Interactive  = require '../interactive/Interactive'
DropdownView = require './DropdownView'
parser       = require 'stout-client/parser'

# Read the button custom HTML tag.
TAG_NAME = vars.readPrefixed 'dropdown/dropdown-tag'

# Register the button tag.
parser.register TAG_NAME, DropdownView, Interactive



module.exports =

  ###*
  # Create a new Dropdown.
  #
  #
  ###
  create: (init) ->
    init = defaults init, {context: new Interactive}
    view = new DropdownView init
    view.context
