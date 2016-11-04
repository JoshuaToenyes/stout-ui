###*
# @overview Defines the `Tab` view-model class for an individual tab.
#
# @module stout-ui/tabs/Tab
###
Interactive     = require '../interactive/Interactive'
SelectableTrait = require '../select/SelectableTrait'
vars            = require '../vars'

# Require shared input variables.
require '../vars/tabs'



###*
# The `Tab` class represents a single content tabs with generic content.
#
# @exports stout-ui/tabs/Tab
# @extends stout-ui/interactive/Interactive
# @constructor
###
module.exports = Interactive.extend 'Tab',

  traits: [SelectableTrait]

  constructor: ->
    Interactive.prototype.constructor.apply @, arguments
    return


  properties:

    'tabTitle':
      default: ''
      type: 'string'
