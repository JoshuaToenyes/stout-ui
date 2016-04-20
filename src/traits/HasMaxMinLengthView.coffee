###*
# @overview Defines the `HasMaxMinLengthView` which describes a component which
# can have the `maxlength` and `minlength` attributes/properties.
#
# @module stout-ui/component/HasMaxMinLength
###
Foundation      = require 'stout-core/base/Foundation'
HasMaxMinLength = require './HasMaxMinLength'


###*
# List of properties to sync between the view and view-model.
#
# @type string
# @inner
###
SYNCED_PROPERTIES = '
  maxlength
  maxlengthWarning
  minlength'



###*
# The `HasMaxMinLengthView` trait defines a component which has `maxlength` and
# `minlength` properties, attributes, and validators. By default, the maxlength
# is set to Infinity and the minlength to zero, so neither is technically
# required.
#
# @exports stout-ui/traits/HasMaxMinLengthView
# @mixin
###
module.exports = class HasMaxMinLengthView extends Foundation

  @cloneProperty HasMaxMinLength, SYNCED_PROPERTIES


  ###*
  # Initiates this trait.
  #
  # @method initTrait
  # @memberof stout-ui/traits/HasMaxMinLengthView#
  # @private
  ###
  initTrait: ->
    @syncProperty @context, SYNCED_PROPERTIES, inherit: false
