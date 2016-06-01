###*
# @overview Defines the `AccordionItemView` view class, the view part of an
# individual item within an accordion.
#
# @module stout-ui/accordion/AccordionItemView
###
defaults                 = require 'lodash/defaults'
HasCollapsibleStatesView = require '../traits/HasCollapsibleStatesView'
InteractiveView          = require '../interactive/InteractiveView'
template                 = require './accordion.template'
vars                     = require '../vars'

# Require shared input variables.
require '../vars/accordion'


###*
# The custom tag name.
#
# @type string
# @const
# @private
###
TAG_NAME = vars.readPrefixed 'accordion/accordion-item-tag'


###*
# The custom tag name.
#
# @type string
# @const
# @private
###
ACCORDION_TRIGGER_TAG_NAME = vars.readPrefixed 'accordion/accordion-trigger-tag'


###*
# The accordion item class name.
#
# @type string
# @const
# @private
###
ACCORDION_ITEM_CLASS = vars.read 'accordion/accordion-item-class'



###*
# The `AccordionItemView` is a pair of an accordion trigger and accordion
# content.
#
# @exports stout-ui/accordion/AccordionItemView
# @extends stout-ui/interactive/InteractiveView
# @constructor
###
module.exports = class AccordionItemView extends InteractiveView

  @useTrait HasCollapsibleStatesView

  constructor: (init, events) ->
    defaults init, {
      template,
      tagName: TAG_NAME,
      setParentCollapsibleState: true
    }
    super init, events

    @prefixedClasses.add ACCORDION_ITEM_CLASS

    @root.setAttribute 'role', 'listitem'


  __getTrigger: ->
    @children.getFirst(ACCORDION_TRIGGER_TAG_NAME)


  collapse: ->
    trigger = @__getTrigger()
    if trigger then trigger.collapse()


  expand: ->
    trigger = @__getTrigger()
    if trigger then trigger.expand()
