###*
# @overview Defines the `AccordionContentView` view class, the view portion of an
# accordion.
#
# @module stout-ui/accordion/AccordionContentView
###
defaults        = require 'lodash/defaults'
CollapsibleView = require '../traits/CollapsibleView'
InteractiveView = require '../interactive/InteractiveView'
template        = require './accordion.template'
vars            = require '../vars'

# Require shared input variables.
require '../vars/accordion'


###*
# The custom tag name.
#
# @type string
# @const
# @private
###
TAG_NAME = vars.readPrefixed 'accordion/accordion-content-tag'


###*
# The accordion content class name.
#
# @type string
# @const
# @private
###
ACCORDION_CONTENT_CLASS = vars.read 'accordion/accordion-content-class'



###*
# The `AccordionContentView` class is the portion of an accordion item which
# can be expanded and collapsed, revealing or hiding the content.
#
# @exports stout-ui/accordion/AccordionContentView
# @extends stout-ui/interactive/InteractiveView
# @constructor
###
module.exports = class AccordionContentView extends InteractiveView

  @useTrait CollapsibleView

  constructor: (init, events) ->
    defaults init, {template, tagName: TAG_NAME}
    super init, events

    @prefixedClasses.add ACCORDION_CONTENT_CLASS

    @root.setAttribute 'role', 'list'
