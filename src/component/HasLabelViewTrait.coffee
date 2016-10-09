###*
# @overview Defines the `HasLabelViewTrait` which can be added to a view or
# view component to add a label property.
#
# @module stout-ui/component/HasLabelViewTrait
###
Foundation = require 'stout-core/base/Foundation'

# Require necessary shared variables.
require '../vars/component'


###*
# The class name of the select box label, applied if using the `label` property.
# @type string
# @const
# @private
###
LABEL_CLS = vars.readPrefixed 'component/label-class'



###*
# The HasLabelViewTrait simply defines a view or component that has a `label`
# property. When setting the `label` property, the `content` property is
# automatically set with the associated HTML string for the label. This
# generalizes the common label-property pattern.
#
# @exports stout-ui/component/HasLabelViewTrait
# @mixin
###
module.exports = class HasLabelViewTrait extends Foundation

  ###*
  # The label.
  #
  # @member {string} label
  # @memberof stout-ui/component/HasLabelViewTrait#
  ###
  @property 'label',
    default: ''


  @property 'contents',
    get: ->
      "<span class=#{LABEL_CLS}>#{@label}</span>"


  ###*
  # Init this trait by syncing with the view's context.
  #
  #
  # @method initTrait
  # @memberof stout-ui/component/HasLabelViewTrait#
  # @private
  ###
  initTrait: ->
    @syncProperty @context, 'label', inherit: false
