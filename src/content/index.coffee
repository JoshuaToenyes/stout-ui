###*
# @overview Registers the custom content tag.
#
# @module stout-ui/content
###
defaults    = require 'lodash/defaults'
Component   = require '../component/Component'
ContentView = require './ContentView'
parser      = require 'stout-client/parser'

# Read the custom content HTML tag.
TAG_NAME = vars.readPrefixed 'content/content-tag'

# Register the content tag with the parser.
parser.register TAG_NAME, ContentView, Component

module.exports = (init) ->

  factory: (init) ->
    defaults init, {context: new Component}
    (new ContentView init).context
