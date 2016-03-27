###*
# @overview Registers the custom button tag.
#
# @module stout-ui/button
###
Interactive = require '../interactive/Interactive'
ButtonView  = require './ButtonView'
parser      = require 'stout-client/parser'

# Read the button custom HTML tag.
TAG_NAME = vars.readPrefixed 'button/button-tag'

# Register the button tag.
parser.register TAG_NAME, ButtonView, Interactive
