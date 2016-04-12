###*
# @overview Defines the `HasValidationMsgViewTrait`
#
# @module stout-ui/traits/HasValidationMsgViewTrait
###
Foundation            = require 'stout-core/base/Foundation'
HasValidationMsgTrait = require './HasValidationMsgTrait'
sortBy                = require 'lodash/sortBy'
uuid                  = require 'uuid'
vars                  = require '../vars'

# Pull-in validation shared vars.
require '../vars/validation-messages'


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
# @exports stout-ui/traits/HasValidationMsgViewTrait
# @mixin
###
module.exports = class HasValidationMsgViewTrait extends Foundation

  @cloneProperty HasValidationMsgTrait, 'hint maxValidationMessages'

  ###*
  # Renders the validation message list.
  #
  # @method _renderValidationMessageList
  # @memberof stout-ui/traits/HasValidationMsgViewTrait
  # @private
  ###
  _renderValidationMessageList: ->
    m = @maxValidationMessages

    # Sort the validation messages so errors appear on top of warnings, and
    # warnings appear on top of hints (in case we're displaying a bunch).
    @_validationMsgs = sortBy(@_validationMsgs, (o) -> o.p).slice 0, m

    if @ready
      ul = @select ".#{MSG_LIST_CLS}"
      ul.innerHTML = ''

      for o in @_validationMsgs
        li = document.createElement 'li'
        li.innerHTML = o.msg

        switch o.p
          when 2 then c = ERROR_CLS
          when 1 then c = WARN_CLS
          when 0 then c = HINT_CLS

        li.classList.add c
        if ul.firstChild
          ul.insertBefore li, ul.firstChild
        else
          ul.appendChild li


  _handleValidationMsgPush: (p, msg, id) ->
    if msg.length is 0 then return
    @removeValidationMessage(id or msg)
    id ?= uuid.v4()
    @_validationMsgs.push {p, msg, id}
    @_renderValidationMessageList()
    id


  removeValidationMessage: (identifier) ->
    i = 0
    while i < @_validationMsgs.length
      m = @_validationMsgs[i]
      if m.id is identifier or m.msg is identifier
        @_validationMsgs.splice i, 1
      else
        i++
    @_renderValidationMessageList()


  showHint: ->
    @_handleValidationMsgPush 0, arguments...


  showValidationError: ->
    @_handleValidationMsgPush 2, arguments...


  showValidationWarning: ->
    @_handleValidationMsgPush 1, arguments...


  ###*
  # Initiates this trait...
  #
  # @method initTrait
  # @memberof stout-ui/traits/HasValidationMsgViewTrait
  # @private
  ###
  initTrait: ->
    @syncProperty @context, 'hint maxValidationMessages', inherit: false
    @_validationMsgs = []

    @showHint @hint

    @on 'change:hint', (e) => @showHint e.data.value

    @on 'ready', => @_renderValidationMessageList()

    @viewClasses.validationMessageList = MSG_LIST_CLS

    if @context.eventRegistered 'validation'

      @context.on 'change:validation', (e) =>
        @classes.remove ERROR_CLS, WARN_CLS
        @prefixedClasses.remove 'valid'
        switch e.data.value
          when 'ok' then @prefixedClasses.add 'valid'
          when 'error' then @classes.add ERROR_CLS
          when 'warning' then @classes.add WARN_CLS

      @context.on 'validation', (e) =>
        msg = e.data.message
        id = e.data.id
        switch e.data.validation
          when 'ok' then @removeValidationMessage(id or msg)
          when 'hint' then @showHint msg, id
          when 'warning' then @showValidationWarning msg, id
          when 'error' then @showValidationError msg, id
