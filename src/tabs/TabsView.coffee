###*
# @overview Defines the `TabsView` view class.
#
# @module stout-ui/tabs/TabsView
###
defaults              = require 'lodash/defaults'
InteractiveView       = require '../interactive/InteractiveView'
Promise               = require 'stout-core/promise/Promise'
template              = require './tabs.template'
TransitionCanceledExc = require('stout-client/exc').TransitionCanceledExc
vars                  = require '../vars'

# Require shared input variables.
require '../vars/tabs'

###*
# The tabs custom tag name.
#
# @type string
# @const
# @private
###
TAG_NAME = vars.readPrefixed 'tabs/tabs-tag'


###*
# Individual tab tag name.
#
# @type string
# @const
# @private
###
TAB_TAG_NAME = vars.readPrefixed 'tabs/tab-tag'


###*
# The class name added to a tabs component.
#
# @type string
# @const
# @private
###
TABS_CLASS = vars.read 'tabs/tabs-class'


###*
# Class name added to each tab.
#
# @type string
# @const
# @private
###
TAB_CLASS = vars.read 'tabs/tab-class'


###*
# Class name added to the currently selected tab.
#
# @type string
# @const
# @private
###
TAB_SELECTED_CLASS = vars.read 'tabs/tab-selected-class'


###*
# The class name added to the UL which holds the actual tab elements.
#
# @type string
# @const
# @private
###
TABS_LIST_CLASS = vars.readPrefixed 'tabs/tabs-list-class'


###*
# The class name added to the container element which holds the tab list.
#
# @type string
# @const
# @private
###
TABS_CONTAINER_CLASS = vars.readPrefixed 'tabs/tabs-container-class'


###*
# The class name added to the sliding highlighter element, which highlights
# the selected tab.
#
# @type string
# @const
# @private
###
TAB_HIGHLIGHT_CLASS = vars.readPrefixed 'tabs/tab-highlight-class'


###*
# Adds parsed tabs to context when the tabs component is rendered.
#
# @function onReady
# @this stout-ui/tabs/TabsView#
###
onReady = ->
  tabs = @children.get(TAB_TAG_NAME)
  for tab in tabs
    @context.tabs.add tab
  selectTab.call @, 0


###*
# Handles when a tab is added to the tabs component.
#
# @function onTabAdd
# @this stout-ui/tabs/TabsView#
###
onTabAdd = (e) ->
  tab = e.data
  tabsList = @select(".#{TABS_LIST_CLASS}")
  tabEl = document.createElement 'li'
  tabEl.classList.add TAB_CLASS
  tabEl.innerHTML = "<span>#{tab.tabTitle}</span>"
  tabsList.appendChild tabEl
  # @addEventListenerTo tabEl, 'mouseleave', onTabMouseLeave, @
  # @addEventListenerTo tabEl, 'mouseover', onTabMouseOver, @
  @addEventListenerTo tabEl, 'tap', onTabTap, @
  updateContainerWidth.call @


###*
# Updates the width of the tab content container so each tab fills the width
# of the tab container.
#
# @function updateContainerWidth
# @this stout-ui/tabs/TabsView#
###
updateContainerWidth = ->
  tabCount = @context.tabs.length
  @select(".#{@prefix}contents").style.width = "#{tabCount * 100}%"



selectTab = (tabIndex) ->
  tabs = @selectAll ".#{TAB_CLASS}", (el) ->
    el.classList.remove(TAB_SELECTED_CLASS)
  tab = tabs[tabIndex]
  tab.classList.add TAB_SELECTED_CLASS
  moveTabHighlight.call @
  moveTabContent.call @, tabIndex


onSelectedTabChange = (e) ->
  selectTab.call @, e.data.value


onTabTap = (e) ->
  tabs = Array::slice.call @selectAll(".#{TAB_CLASS}")
  selectTab.call @, tabs.indexOf(e.source)


moveTabContent = (tabIndex) ->
  @select(".#{@prefix}contents").style.marginLeft = "#{-tabIndex * 100}%"



moveTabHighlight = ->
  highlight = @select ".#{TAB_HIGHLIGHT_CLASS}"
  selectedTab = @select ".#{TAB_SELECTED_CLASS} span"
  r = selectedTab.getBoundingClientRect()
  for p in ['height', 'width']
    highlight.style[p] = "#{r[p]}px"
  highlight.style.left = "#{selectedTab.offsetLeft}px"
  highlight.style.top = "#{selectedTab.offsetTop}px"


###*
# The `TabsView` class represents the view of a single content tabs with
# generic content.
#
# @exports stout-ui/tabs/TabsView
# @extends stout-ui/interactive/InteractiveView
# @constructor
###
module.exports = InteractiveView.extend 'TabsView',

  constructor: (init, events) ->
    init = defaults init, {template, tagName: TAG_NAME}
    InteractiveView::constructor.call @, init, events
    @prefixedClasses.add TABS_CLASS

    @viewClasses.tabsContainer = TABS_CONTAINER_CLASS
    @viewClasses.tabHighlight = TAB_HIGHLIGHT_CLASS
    @viewClasses.tabsList = TABS_LIST_CLASS

    @context.tabs.on 'add', onTabAdd, @
    @context.on 'change:selectedTab', onSelectedTabChange, @
    @on 'ready', onReady, @

    return
