###*
# @overview Registers the custom tabs tag.
#
# @module stout-ui/tabs
###
defaults = require 'lodash/defaults'
Tab      = require './Tab'
Tabs     = require './Tabs'
TabView  = require './TabView'
TabsView = require './TabsView'
parser   = require 'stout-client/parser'

# Read the button custom HTML tag.
TABS_TAG_NAME = vars.readPrefixed 'tabs/tabs-tag'
TAB_TAG_NAME  = vars.readPrefixed 'tabs/tab-tag'

# Register the button tag.
parser.register TABS_TAG_NAME, TabsView, Tabs
parser.register TAB_TAG_NAME, TabView, Tab


module.exports = (init) ->

  factory: (init) ->
    defaults init, {context: new Tabs}
    (new TabsView init).context
