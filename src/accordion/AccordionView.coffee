###*
# @overview Defines the `AccordionView` view class, the view portion of an
# accordion.
#
# @module stout-ui/accordion/AccordionView
###
defaults                 = require 'lodash/defaults'
CollapsibleView          = require '../traits/CollapsibleView'
InteractiveView          = require '../interactive/InteractiveView'
HasCollapsibleStatesView = require '../traits/HasCollapsibleStatesView'
template                 = require './accordion.template'
vars                     = require '../vars'

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
# The accordion custom tag name.
#
# @type string
# @const
# @private
###
ACCORDION_ITEM_TAG_NAME = vars.readPrefixed 'accordion/accordion-item-tag'


###*
# The `AccordionView` class represents the view part of an accordion.
#
# @exports stout-ui/accordion/AccordionView
# @extends stout-ui/interactive/InteractiveView
# @constructor
###
module.exports = class AccordionView extends InteractiveView

  @useTrait HasCollapsibleStatesView

  constructor: (init, events) ->
    defaults init, {template, tagName: TAG_NAME}
    super init, events

    @prefixedClasses.add ACCORDION_CLASS

    @root.setAttribute 'role', 'list'

    self = @
    @on 'ready', ->
      @children.get(ACCORDION_ITEM_TAG_NAME).forEach (item) ->
        item.on 'change:expanding', (e) ->
          self.children.get(ACCORDION_ITEM_TAG_NAME).forEach (item) ->
            if item isnt e.source
              item.collapse()


  expandItem: (item) ->


  collapseItem: (item) ->
