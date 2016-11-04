###*
# @overview Defines the `Tabs` view-model class.
#
# @module stout-ui/tabs/Tabs
###
Interactive = require '../interactive/Interactive'
OrderedList = require 'stout-core/collection/OrderedList'
vars        = require '../vars'

# Require shared input variables.
require '../vars/tabs'



###*
# The `Tabs` class represents a group of individual tabs.
#
# @exports stout-ui/tabs/Tabs
# @extends stout-ui/interactive/Interactive
# @constructor
###
module.exports = Interactive.extend 'Tabs',

  constructor: ->
    Interactive.prototype.constructor.apply @, arguments
    return


  properties:

    ###*
    # The set of individual tabs.
    #
    # @member {stout-core/collection/OrderedList} tabs
    # @memberof stout-ui/tabs/Tabs#
    ###
    'tabs':
      default: -> new OrderedList


    ###*
    # The currently selected tab.
    #
    # @member {stout-ui/tabs/Tab} selectedTab
    # @memberof stout-ui/tabs/Tabs#
    ###
    'selectedTab': {}
