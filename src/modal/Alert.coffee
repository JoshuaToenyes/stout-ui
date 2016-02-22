###*
# @overview Defines the Dialog class, which is a special type of modal window
# meant to require input from the user.
# @module stout-ui/modal/Dialog
###

Modal = require './Modal'
Button = require '../button/Button'
Component = require '../common/Component'
template = require './alert.template'
omit = require 'lodash/omit'
pick = require 'lodash/pick'
Promise = require 'stout-core/promise/Promise'


###*
# The class to add to the root alert modal element.
# @const
# @type string
# @private
###
ALERT_CLS = vars.read 'modal/alert-class'


###*
# Class to apply to alert content root element.
# @const
# @type string
# @private
###
ALERT_CONTENTS_CLS = vars.read 'modal/alert-contents-class'


###*
# Alert title container class.
# @const
# @type string
# @private
###
ALERT_TITLE_CLS = vars.readPrefixed 'modal/alert-title-class'


###*
# Alert body container class.
# @const
# @type string
# @private
###
ALERT_BODY_CLS = vars.readPrefixed 'modal/alert-body-class'


###*
# Controls container class.
# @const
# @type string
# @private
###
ALERT_CONTROLS_CLS = vars.readPrefixed 'modal/alert-controls-class'


###*
# List of options which should be forwarded to the dynamically created
# AlertContent instance.
# @const
# @type string
# @private
###
alertOpts = ['title', 'content', 'ok', 'buttonStyle']



class AlertContent extends Component

  @property 'title'

  @property 'content'

  @property 'ok',
    default: 'ok'

  @property 'buttonStyle',
    default: 'normal-flat'

  @property 'titleClass',
    const: true
    value: ALERT_TITLE_CLS

  @property 'bodyClass',
    const: true
    value: ALERT_BODY_CLS

  @property 'controlsClass',
    const: true
    value: ALERT_CONTROLS_CLS

  constructor: (init) ->
    super template, null, {renderOnChange: false}, init
    @prefixedClasses.add ALERT_CONTENTS_CLS

  renderControls: (promise) ->
    new Button
      label: @ok
      parentEl: @select '.' + ALERT_CONTROLS_CLS
      style: @buttonStyle
      click: ->
        Promise.fulfill promise
    .render()


module.exports = class Alert extends Modal

  constructor: (init = {}) ->
    super omit(init, alertOpts)
    @_contents = new AlertContent pick(init, alertOpts)
    @contents = @_contents
    @prefixedClasses.add ALERT_CLS

  open: ->
    clickPromise = new Promise()
    super(arguments...).then =>
      setTimeout =>
        @_contents.renderControls(clickPromise)
      , 50
    clickPromise.then => @close()
    clickPromise
