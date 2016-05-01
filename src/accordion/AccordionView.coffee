###*
# @overview Defines the `AccordionView` view class, the view portion of an
# accordion.
#
# @module stout-ui/accordion/AccordionView
###
defaults        = require 'lodash/defaults'
CollapsibleView = require '../traits/CollapsibleView'
InteractiveView = require '../interactive/InteractiveView'
template        = require './accordion.template'
vars            = require '../vars'

# Require shared input variables.
require '../vars/accordion'


###*
# The accordion custom tag name.
#
# @type string
# @const
# @private
###
TAG_NAME = vars.readPrefixed 'accordion/accordion-tag'


###*
# The accordion class name.
#
# @type string
# @const
# @private
###
ACCORDION_CLASS = vars.read 'accordion/accordion-class'



###*
# The `AccordionView` class represents the view part of an accordion.
#
# @exports stout-ui/accordion/AccordionView
# @extends stout-ui/interactive/InteractiveView
# @constructor
###
module.exports = class AccordionView extends InteractiveView

  constructor: (init, events) ->
    defaults init, {template, tagName: TAG_NAME}
    super init, events

    @prefixedClasses.add ACCORDION_CLASS

    @root.setAttribute 'role', 'list'
