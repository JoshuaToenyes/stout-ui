###*
# @overview
#
# @module stout-ui/traits/CollapsibleTriggerView
###
Foundation           = require 'stout-core/base/Foundation'
HasCollapsibleStates = require './HasCollapsibleStates'


###*
#
#
# @exports stout-ui/traits/Collapsible
# @mixin
###
module.exports = class Collapsible extends Foundation

  @useTrait HasCollapsibleStates
