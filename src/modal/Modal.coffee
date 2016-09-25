###*
# @overview Defines the Modal view-model class.
#
# @module stout-ui/modal/Modal
###
Pane = require '../pane/Pane'
Promise = require 'stout-core/promise/Promise'



###*
# The Modal class is the view-model of a generic modal component.
#
# @exports stout-ui/modal/Modal
# @extends stout-ui/pane/Pane
# @constructor
###
module.exports = class Modal extends Pane

  constructor: (init, events = []) ->
    super init, events.concat ['open', 'close']


  ###*
  # Defines if the modal is closeable by clicking outside the modal on the
  # backdrop. If `true`, then the modal can only be closed programmatically, if
  # `false`, then the modal can be closed by clicking on the backdrop.
  ###
  @property 'static',
    default: true


  open: (e) =>
    promise = new Promise
    @fire 'open', {promise, activator: e?.source.root}
    promise


  close: (e) =>
    promise = new Promise
    @fire 'close', {promise, activator: e?.source.root}
    promise
