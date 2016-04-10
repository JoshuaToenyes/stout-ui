###*
# @overview Defines the `HasValidationMsgViewTrait`
#
# @module stout-ui/traits/HasValidationMsgViewTrait
###
Foundation            = require 'stout-core/base/Foundation'
HasValidationMsgTrait = require './HasValidationMsgTrait'
vars                  = require '../vars'
sortBy                = require 'lodash/sortBy'

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
    @_validationMsgs = sortBy(@_validationMsgs, (o) -> o.p).slice 0, m
    if @ready
      ul = @select ".#{MSG_LIST_CLS}"
      ul.innerHTML = ''
      for o in @_validationMsgs
        li = document.createElement 'li'
        li.innerHTML = o.msg
        switch o.p
          when 0 then c = ERROR_CLS
          when 1 then c = WARN_CLS
          when 2 then c = HINT_CLS
        li.classList.add c
        if ul.firstChild
          ul.insertBefore li, ul.firstChild
        else
          ul.appendChild li


  _handleValidationMsgPush: (p, msg) ->
    if msg.length is 0 then return
    @_validationMsgs.push {p, msg}
    @_renderValidationMessageList()


  showHint: (msg) ->
    @_handleValidationMsgPush 2, msg


  showValidationWarning: (msg) ->
    @_handleValidationMsgPush 1, msg


  showValidationError: (msg) ->
    @_handleValidationMsgPush 0, msg


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
