###*
# @overview Defines the `HasValidators` trait which adds validation
# messages to a component.
#
# @module stout-ui/input/HasValidators
###
Foundation = require 'stout-core/base/Foundation'



###*
# The `HasValidatorsView`
#
# @exports stout-ui/traits/HasValidatorsView
# @mixin
###
module.exports = class HasValidatorsView extends Foundation

  initTrait: ->
    @context.on 'validation', (e) ->
