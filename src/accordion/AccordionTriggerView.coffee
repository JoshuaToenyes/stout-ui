###*
# @overview Defines the `AccordionTriggerView` view class, the view portion of an
# accordion item.
#
# @module stout-ui/accordion/AccordionTriggerView
###
defaults               = require 'lodash/defaults'
CollapsibleView        = require '../traits/CollapsibleView'
CollapsibleTriggerView = require '../traits/CollapsibleTriggerView'
InteractiveView        = require '../interactive/InteractiveView'
template               = require './accordion-trigger.template'
vars                   = require '../vars'

# Require shared input variables.
require '../vars/accordion'


###*
# The accordion item custom tag name.
#
# @type string
# @const
# @private
###
TAG_NAME = vars.readPrefixed 'accordion/accordion-trigger-tag'


###*
# The accordion trigger class name.
#
# @type string
# @const
# @private
###
ACCORDION_TRIGGER_CLS = vars.read 'accordion/accordion-trigger-class'



###*
# The `AccordionTriggerView` class represents the view part of an item within
# an accordion component which triggers the expanding/collapsing of an accordion
# item's content.
#
# @exports stout-ui/accordion/AccordionTriggerView
# @extends stout-ui/interactive/InteractiveView
# @constructor
###
module.exports = class AccordionTriggerView extends InteractiveView

  # Use the CollapsibleTriggerView and pass "parent" to the initTrait function.
  # This sets the "ready target" of the trait to this trigger's parent,
  # essentially causing this item to wait until the parent "accordion-item" is
  # rendered before attempting to expand/collpase it. We must do this because
  # in an accordion, the trigger and accordion content are siblins.
  @useTrait CollapsibleTriggerView, args: ['parent']

  constructor: (init, events) ->
    defaults init, {
      template,
      tagName: TAG_NAME,
      setParentCollapsibleState: true
    }
    super init, events

    @prefixedClasses.add ACCORDION_TRIGGER_CLS


  ###*
  # Finds and returns the items which should be collapsed by this trigger.
  #
  # @method _getCollapseTargets
  # @memberof stout-ui/traits/CollapsibleTriggerView#
  # @protected
  ###
  _getCollapseTargets: ->
    @parent.children.get(CollapsibleView)
