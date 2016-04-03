###*
# @overview Defines a radio button group, in-which only a single radio button
# may be selected at a time.
#
# @module stout-ui/radio/RadioGroupView
###
ComponentView = require '../component/ComponentView'
defaults      = require 'lodash/defaults'
isArray       = require 'lodash/isArray'
vars          = require '../vars'

# Require necessary shared variables.
require '../vars/radio-group'


###*
# The class applied to the root radio group element.
# @type string
# @const
# @private
###
RADIO_GROUP_CLS = vars.read 'radio-group/radio-group-class'


###*
# The custom radio group tag name.
# @type string
# @const
# @private
###
TAG_NAME = vars.readPrefixed 'radio-group/radio-group-tag'



###*
# The view of a mutually exclusive set of radio buttons.
#
# @param {Object} [init] - Initiation object.
#
# @param {Array.<string>} [events] - Additional event names to register
# immediately.
#
# @exports stout-ui/radio/RadioGroupView
# @extends stout-ui/component/Component
# @constructor
###
module.exports = class RadioGroupView extends ComponentView

  constructor: (init, events) ->
    defaults init, {tagName: TAG_NAME, template: ''}
    super init, events
    @prefixedClasses.add RADIO_GROUP_CLS


  render: ->
    super().then =>
      if isArray @contents
        for btn in @contents
          @context.add btn.context
    .catch (e) -> console.log e
