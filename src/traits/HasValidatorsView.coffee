###*
# @overview Defines the `HasValidators` trait which adds validation
# messages to a component.
#
# @module stout-ui/input/HasValidators
###
debounce      = require 'lodash/debounce'
Foundation    = require 'stout-core/base/Foundation'
HasValidators = require './HasValidators'
parser        = require '../validator/parser'



###*
# Inner constant used for debouncing validation related functions.
#
# @const number
# @inner
###
VALIDATION_DEBOUNCE = 100



###*
# The `HasValidatorsView`
#
# @exports stout-ui/traits/HasValidatorsView
# @mixin
###
module.exports = class HasValidatorsView extends Foundation

  @cloneProperty HasValidators, 'validatorName'

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
    @syncProperty @context, 'validatorName', inherit: false

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

    # Perform a full validation when the field is blurred. We have to debounce
    # this listener most importantly because we depend on the `#dirty` property
    # being set correctly on the first blur event. This happens syncronously
    # but this method may be called before `#dirty` is set. Therefore, we
    # debounce to ensure the event loop has cleared and the property is set
    # correctly.
    @on 'blur', debounce =>
      if @dirty then doValidation()
    , VALIDATION_DEBOUNCE

    # Trigger a soft validation as soon as the user focuses the component.
    @on 'focus', =>
      @context.validatorGroup.softValidate  @context[@context.validateProperty]

    # When the field changes, perform a live debounced full validation.
    @context.stream "#{@context.validateProperty}", (v) =>
      @context.validatorGroup.softValidate(v)

    # When a view "bump" occurs, also perform a validation.
    @on 'bump:maxlength', (e) =>
      @context.validatorGroup.softValidate(e.data)
