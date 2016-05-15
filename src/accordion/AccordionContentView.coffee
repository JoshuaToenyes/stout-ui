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
# The accordion item tag name.
#
# @type string
# @const
# @private
###
ITEM_TAG_NAME = vars.readPrefixed 'accordion/accordion-item-tag'


###*
# The accordion trigger tag name.
#
# @type string
# @const
# @private
###
TRIGGER_TAG_NAME = vars.readPrefixed 'accordion/accordion-trigger-tag'


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

    @on 'transition:in', =>
      @parent?.parent?.children.get(ITEM_TAG_NAME)?.forEach (item) =>
        if item.parent isnt @parent
          item.children.get(TRIGGER_TAG_NAME).forEach (trigger) ->
            trigger.collapse()
