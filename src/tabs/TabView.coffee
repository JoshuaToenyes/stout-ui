###*
# @overview Defines the `TabView` view class.
#
# @module stout-ui/tab/TabView
###
defaults            = require 'lodash/defaults'
InteractiveView     = require '../interactive/InteractiveView'
Promise             = require 'stout-core/promise/Promise'
SelectableViewTrait = require '../select/SelectableViewTrait'
vars                = require '../vars'

# Require shared input variables.
require '../vars/tabs'


###*
# The tab custom tag name.
#
# @type string
# @const
# @private
###
TAG_NAME = vars.readPrefixed 'tabs/tab-tag'


###*
# The tab class name.
#
# @type string
# @const
# @private
###
TAB_CLASS = vars.read 'tabs/tab-class'



###*
# The `TabView` class represents the view of a single content tab with
# generic content.
#
# @exports stout-ui/tab/TabView
# @extends stout-ui/interactive/InteractiveView
# @constructor
###
module.exports = InteractiveView.extend 'TabView',

  traits: [SelectableViewTrait]

  constructor: (init, events) ->
    init = defaults init, {tagName: TAG_NAME}
    InteractiveView::constructor.call @, init, events
    @prefixedClasses.add TAB_CLASS
    #@options.showOnRender = true
    return

  properties:

    'tabTitle':
      default: ''
      type: 'string'
