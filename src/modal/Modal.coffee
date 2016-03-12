###*
# @overview Defines a basic modal window UI component.
# @module stout-ui/modal/Modal
###

Pane      = require '../pane/Pane'
template  = require './modal.template'
backdrop  = require './backdrop'
vars      = require '../vars'
Promise    = require 'stout-core/promise/Promise'

# Load modal variables.
require '../vars/modal'


###*
# The class to add to the root modal container.
# @const
# @type string
# @private
###
MODAL_CLS = vars.read 'modal/modal-class'


###*
# The modal transition-in time in milliseconds.
# @const
# @type number
# @private
###
TRANS_IN_TIME = vars.readTime 'modal/modal-trans-in-time'


###*
# The modal transition-out time in milliseconds.
# @const
# @type number
# @private
###
TRANS_OUT_TIME = vars.readTime 'modal/modal-trans-out-time'



module.exports = class Modal extends Pane

  ###*
  # MaskedTextInput constructor.
  #
  # @param {Object} [init] - Initiation object.
  #
  # @exports stout-ui/modal/Modal
  # @extends stout-ui/container/Container
  # @constructor
  ###
  constructor: ->
    super arguments...
    @prefixedClasses.add MODAL_CLS


  @property 'width',
    default: 'auto'


  @property 'height',
    default: 'auto'


  ###*
  # Defines if the modal is closeable by clicking outside the modal on the
  # backdrop. If `true`, then the modal can only be closed programmatically, if
  # `false`, then the modal can be closed by clicking on the backdrop.
  ###
  @property 'static',
    default: true


  ###*
  # Set to `true` if the close "x" should be shown on the modal.
  #
  # @property showClose
  # @type boolean
  # @default true
  # @public
  ###
  @property 'showClose',
    default: true


  ##
  # The modal header's title.
  #
  # @property title
  # @type string
  # @default null
  # @public

  @property 'title'


  ###*
  # Window resize event handler. It simply repositions the modal window and
  # its contents.
  #
  # @method _resizeHandler
  # @memberof stout-ui/modal/Modal#
  # @protected
  ###
  _resizeHandler: =>
    @setFinalSize()


  ###*
  # Closes this modal window.
  #
  #
  # @memberof stout-ui/modal/Modal#
  # @public
  ###
  close: ->
    closePromise = new Promise()

    backdrop().transitionOut()

    window.removeEventListener 'resize', @_resizeHandler

    @transitionOut TRANS_OUT_TIME, =>
      Promise.resolve closePromise
      @unrender()


  ###*
  # Opens the modal window.
  #
  # @param {Event} [e] - Event that triggered the opening of this modal.
  #
  # @method open
  # @memberof stout-ui/modal/Modal#
  # @public
  ###
  open: (e) =>
    openPromise = new Promise()

    @render()

    # Capture the activating component (button, etc.) if present.
    @_activator = e?.source.root

    # If this modal isn't static, then attach an event listener so it's closed
    # when/if the user clicks on the backdrop.
    if not @static
      backdrop().once 'transition:out', =>
        @close()
        Promise.reject openPromise

    # Initiate the modal transition.
    @transitionIn TRANS_IN_TIME, ->
      Promise.fulfill openPromise

    # When the window is resizes, reposition the modal and its contents.
    window.addEventListener 'resize', @_resizeHandler

    # Show the backdrop, making it inherit the modal's "static" state.
    backdrop().static = @static
    backdrop().transitionIn()

    openPromise
