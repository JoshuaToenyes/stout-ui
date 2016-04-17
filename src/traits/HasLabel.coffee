###*
# @overview Defines the `HasLabelViewTrait` which can be added to a view or
# view component to add a label property.
#
# @module stout-ui/component/HasLabelViewTrait
###
Foundation = require 'stout-core/base/Foundation'



###*
# The `HasLabel` trait defines a view model which has a synced `label` property
# with its corresponding view.
#
# @exports stout-ui/traits/HasLabel
# @mixin
###
module.exports = class HasLabel extends Foundation

  ###*
  # The label.
  #
  # @member {string} label
  # @memberof stout-ui/traits/HasLabel
  ###
  @property 'label'
