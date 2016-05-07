###*
# @overview Defines the view class for a content component.
#
# @module stout-ui/content/ContentView
###
ComponentView = require '../component/ComponentView'
defaults      = require 'lodash/defaults'
vars          = require '../vars'

# Load content variables.
require '../vars/content'


###*
# The class to add to the content root element.
#
# @const {string}
# @private
###
CONTENT_CLS = vars.read 'content/content-class'


###*
# The content custom tag name.
#
# @const {string}
# @private
###
TAG_NAME = vars.readPrefixed 'content/content-tag'



###*
# The view class for a content container custom element.
#
# @param {Object} [init] - Initiation object.
#
# @exports stout-ui/content/ContentView
# @extends stout-ui/component/ComponentView
# @constructor
###
module.exports = class DrawerView extends ComponentView

  constructor: (init, events) ->
    defaults init, {tagName: TAG_NAME}
    super arguments...

    @prefixedClasses.add CONTENT_CLS
