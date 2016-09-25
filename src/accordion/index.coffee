###*
# @overview Registers the accordion component tags and provides factories.
#
# @module stout-ui/accordion
###
AccordionContentView = require './AccordionContentView'
AccordionItemView    = require './AccordionItemView'
AccordionTriggerView = require './AccordionTriggerView'
AccordionView        = require './AccordionView'
defaults             = require 'lodash/defaults'
namespace            = require '../util/namespace'
Interactive          = require '../interactive/Interactive'
InteractiveView      = require '../interactive/InteractiveView'
parser               = require 'stout-client/parser'

# Read the custom HTML tag names.
ACCORDION_TAG_NAME = vars.readPrefixed 'accordion/accordion-tag'
ACCORDION_ITEM_TAG_NAME = vars.readPrefixed 'accordion/accordion-item-tag'
ACCORDION_TRIGGER_TAG_NAME = vars.readPrefixed 'accordion/accordion-trigger-tag'
ACCORDION_CONTENT_TAG_NAME = vars.readPrefixed 'accordion/accordion-content-tag'

# Register the custom tags.
parser.register ACCORDION_TAG_NAME, AccordionView, Interactive
parser.register ACCORDION_ITEM_TAG_NAME, AccordionItemView, Interactive
parser.register ACCORDION_TRIGGER_TAG_NAME, AccordionTriggerView, Interactive
parser.register ACCORDION_CONTENT_TAG_NAME, AccordionContentView, Interactive

accordion =

  factory: (init = {}) ->
    defaults init, {context: new Interactive}
    (new AccordionView init).context

  itemFactory: (triggerInit = {}, contentInit = {}, itemInit = {}) ->

    # Initialize the accordion item.
    defaults contentInit, {context: new Interactive}
    item = new AccordionItemView contentInit

    # Initialize the accordion trigger and content, linking both to the parent.
    defaults triggerInit, {context: new Interactive, parent: item}
    defaults itemInit, {context: new Interactive, parent: item}
    trigger = new AccordionTriggerView triggerInit
    content = new AccordionContentView contentInit

    # Return the accordion item.
    item

namespace '$stout.ui.accordion', accordion

module.exports = accordion
