###*
# @overview Defines the view class for a content component.
#
# @module stout-ui/content/ContentView
###
ComponentView   = require '../component/ComponentView'
defaults        = require 'lodash/defaults'
ScrollableView  = require '../traits/ScrollableView'
template        = require './content.template'
vars            = require '../vars'

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
module.exports = class ContentView extends ComponentView

  #@useTrait ScrollableView

  constructor: (init, events) ->
    defaults init, {tagName: TAG_NAME, template}
    super arguments...

    @prefixedClasses.add CONTENT_CLS
