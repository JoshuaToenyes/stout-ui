###*
# @overview Registers the custom drawer tag.
#
# @module stout-ui/drawer
###
defaults   = require 'lodash/defaults'
Drawer     = require './Drawer'
DrawerView = require './DrawerView'
parser     = require 'stout-client/parser'

# Read the custom drawer HTML tag.
TAG_NAME = vars.readPrefixed 'drawer/drawer-tag'

# Register the drawer tag with the parser.
parser.register TAG_NAME, DrawerView, Drawer

module.exports = (init) ->

  factory: (init) ->
    defaults init, {context: new Drawer}
    (new DrawerView init).context
