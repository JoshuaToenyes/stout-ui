###*
# @overview Defines the `HasValidationMsgView`
#
# @module stout-ui/traits/HasValidationMsgView
###
debounce         = require 'lodash/debounce'
Foundation       = require 'stout-core/base/Foundation'
HasValidationMsg = require './HasValidationMsg'
OrderedList      = require 'stout-core/collection/OrderedList'
sortBy           = require 'lodash/sortBy'
uuid             = require 'uuid'
vars             = require '../vars'

# Pull-in validation shared vars.
require '../vars/validation-messages'


# Sorting Constants
ERR = 1
WARN = 2
HINT = 3



###*
# Read the class name attached to the validation messages list.
#
# @type string
# @const
# @private
###
MSG_LIST_CLS = vars.readPrefixed 'validation-messages/validation-msg-ul-class'


###*
# Hint message class name.
#
# @type string
# @const
# @private
###
HINT_CLS = vars.readPrefixed 'validation-messages/validation-msg-hint-class'


###*
# Warning message class name.
#
# @type string
# @const
# @private
###
WARN_CLS = vars.readPrefixed 'validation-messages/validation-msg-warning-class'


###*
# Error message class name.
#
# @type string
# @const
# @private
###
ERROR_CLS = vars.readPrefixed 'validation-messages/validation-msg-error-class'


###*
# The HasHintViewTrait can be used for input-type components which have a hint
# message.
#
# @exports stout-ui/traits/HasValidationMsgView
# @mixin
###
module.exports = class HasValidationMsgView extends Foundation

  @cloneProperty HasValidationMsg, 'hint maxValidationMessages'

  ###*
  # Renders the validation message list.
  #
  # @method _renderValidationMessageList
  # @memberof stout-ui/traits/HasValidationMsgView
  # @private
  ###
  _renderValidationMessageList: ->
    m = @maxValidationMessages

    # Sort the validation messages so errors appear on top of warnings, and
    # warnings appear on top of hints (in case we're displaying a bunch).
    msgs = (@_validationMsgs.sortBy('p').take m).reverse()

    if @ready
      ul = @select ".#{MSG_LIST_CLS}"
      ul.innerHTML = ''

      for o in msgs
        li = document.createElement 'li'
        li.innerHTML = o.msg

        switch o.p
          when ERR then c = ERROR_CLS
          when WARN then c = WARN_CLS
          when HINT then c = HINT_CLS

        li.classList.add c
        if ul.firstChild
          ul.insertBefore li, ul.firstChild
        else
          ul.appendChild li


  ###*
  # Handles adding a validation message. After a message is added a re-render
  # of the list is requested.
  #
  # @param {string} identifier - Either the messsage ID or exact message string
  # to remove.
  #
  # @method _handleValidationMsgPush
  # @memberof stout-ui/traits/HasValidationMsgView#
  # @private
  ###
  _handleValidationMsgPush: (p, msg, id) ->
    if msg.length is 0 then return
    @removeValidationMessage(id or msg)
    id ?= uuid.v4()
    @_validationMsgs.add {p, msg, id}
    @_renderValidationMessageList()
    id


  ###*
  # Handles when a validation occurs.
  #
  # @method _onValidation
  # @memberof stout-ui/traits/HasValidationMsgView
  # @private
  ###
  _onValidation: (e) ->
    msg = e.data.message
    id = e.data.id
    switch e.data.validation
      when 'ok' then @removeValidationMessage(id or msg)
      when 'hint' then @showHint msg, id
      when 'warning' then @showValidationWarning msg, id
      when 'error' then @showValidationError msg, id


  ###*
  # Handle a validation state change event. This occurs when the overall
  # validation shifts from one state to another (e.g. "hint" to "error").
  #
  # @method _onValidationChange
  # @memberof stout-ui/traits/HasValidationMsgView
  # @private
  ###
  _onValidationChange: (e) ->
    @classes.remove ERROR_CLS, WARN_CLS
    @prefixedClasses.remove 'valid'
    switch e.data.value
      when 'ok' then @prefixedClasses.add 'valid'
      when 'error' then @classes.add ERROR_CLS
      when 'warning' then @classes.add WARN_CLS


  ###*
  # Removes a validation message.
  #
  # @param {string} identifier - Either the messsage ID or exact message string
  # to remove.
  #
  # @method removeValidationMessage
  # @memberof stout-ui/traits/HasValidationMsgView#
  ###
  removeValidationMessage: (identifier) ->
    @_validationMsgs.all (m) =>
      if m.id is identifier or m.msg is identifier
        @_validationMsgs.remove m
    @_renderValidationMessageList()


  ###*
  # Shows a hint message.
  #
  # @param {string} message - The string message to show.
  #
  # @param {string} [id] - The optional validation message ID.
  #
  # @method showHint
  # @memberof stout-ui/traits/HasValidationMsgView#
  ###
  showHint: ->
    @_handleValidationMsgPush HINT, arguments...


  ###*
  # Shows a validation error message.
  #
  # @param {string} message - The string message to show.
  #
  # @param {string} [id] - The optional validation message ID.
  #
  # @method showValidationError
  # @memberof stout-ui/traits/HasValidationMsgView#
  ###
  showValidationError: ->
    @_handleValidationMsgPush ERR, arguments...


  ###*
  # Shows a validation warning message.
  #
  # @param {string} message - The string message to show.
  #
  # @param {string} [id] - The optional validation message ID.
  #
  # @method showValidationWarning
  # @memberof stout-ui/traits/HasValidationMsgView#
  ###
  showValidationWarning: ->
    @_handleValidationMsgPush WARN, arguments...


  ###*
  # Initiates this trait...
  #
  # @method initTrait
  # @memberof stout-ui/traits/HasValidationMsgView
  # @private
  ###
  initTrait: ->

    # The hint value is not inherited because it may be specified in the
    @syncProperty @context, 'hint', inherit: false

    # The maximum validation messages should be set by the implementing context
    # view model class.
    @syncProperty @context, 'maxValidationMessages'

    @_validationMsgs = new OrderedList()

    # The validation message list must be rendered immediately to show any
    # validation messages which were updated before ready/rendered.
    @on 'ready', => @_renderValidationMessageList()

    # Add the validation message list to the list of view classes, usable by
    # templates at render-time.
    @viewClasses.validationMessageList = MSG_LIST_CLS

    # If the view-model doesn't support the `validation` event, then this
    # trait can only show/hide validation messages manually.
    if @context.eventRegistered 'validation'

      # When the validation status of the view-model changes, update the
      # displayed validation classes (error, warning, hint, etc.).
      @context.on 'change:validation', @_onValidationChange, @

      # When the view-model fires a validation event (meaning a validation just
      # occurred), update the validation messages.
      @context.on 'validation', @_onValidation, @
