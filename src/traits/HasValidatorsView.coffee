###*
# @overview Defines the `HasValidators` trait which adds validation
# messages to a component.
#
# @module stout-ui/input/HasValidators
###
debounce   = require 'lodash/debounce'
Foundation = require 'stout-core/base/Foundation'
parser     = require '../validator/parser'


VALIDATION_DEBOUNCE = 300

###*
# The `HasValidatorsView`
#
# @exports stout-ui/traits/HasValidatorsView
# @mixin
###
module.exports = class HasValidatorsView extends Foundation

  ###*
  # The `validators` attribut on views which include this trait. `Validator`
  # classes are automatically instantiated based on this property.
  #
  # @member validators
  # @memberof stout-ui/traits/HasValidatorsView#
  ###
  @property 'validators',
    default: ''


  ###*
  # Optional field name for use by validators.
  #
  # @member validatorName
  # @memberof stout-ui/traits/HasValidatorsView#
  ###
  @property 'validatorName'


  ###*
  # Set to `true` to enabled the "required" validator for this field.
  #
  # @member required
  # @memberof stout-ui/traits/HasValidatorsView#
  ###
  @property 'required',
    default: false
    type: 'boolean'


  ###*
  # Initiates this trait.
  #
  # @method initTrait
  # @memberof stout-ui/traits/HasValidatorsView#
  # @private
  ###
  initTrait: ->
    # Add the "required" validator if the attribute has been set.
    if @required then @validators += '|required'

    # Parse the described validators.
    if @validators.trim().length > 0
      for v in parser.parse(@validators)
        v.name = @validatorName or @label
        @context.validators.add v

    # Handles actually performing the full validation using the view-model's
    # validator group.
    doValidation = =>
      if @visited
        @context.validatorGroup.validate @context[@context.validateProperty]

    # This function handles debounced, live validation.
    doLiveValidation = debounce ->
      doValidation()
    , VALIDATION_DEBOUNCE

    # Perform a full validation when the field is blurred.
    @on 'blur', => if @dirty then doValidation()

    @on 'focus', =>
      val = @context[@context.validateProperty]
      @context.validatorGroup.softValidate(val)

    # When the field changes, perform a live debounced full validation.
    @context.on "change:#{@context.validateProperty}", doLiveValidation
