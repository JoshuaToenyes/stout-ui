###*
# @overview Defines a basic modal window UI component.
# @module stout-ui/modal/ModalView
###
PaneView = require '../pane/PaneView'
backdrop = require './backdrop'
vars     = require '../vars'
Modal    = require './Modal'
Promise  = require 'stout-core/promise/Promise'

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



###*
# The ModalView class is the view portion of a generic modal container.
#
# @param {Object} [init] - Initiation object.
#
# @exports stout-ui/modal/ModalView
# @extends stout-ui/pane/PaneView
# @constructor
###
module.exports = class ModalView extends PaneView

  constructor: ->
    super arguments...

    @options.showOnRender = false

    @syncProperty @context, 'static', {inherit: false}

    @transition = 'zoom'
    @height = 0.8
    @width = 'auto'
    #@width = 0.62
    @prefixedClasses.add MODAL_CLS

    @context.on 'open', @open, @
    @context.on 'close', @close, @

    @render()

  @cloneProperty Modal, 'static'


  ###*
  # Closes this modal window.
  #
  #
  # @memberof stout-ui/modal/ModalView#
  # @public
  ###
  close: (e) ->
    closePromise = e?.data.promise or new Promise()

    backdrop().transitionOut()

    Promise.resolve closePromise, @transitionOut()

    closePromise


  ###*
  # Opens the modal window.
  #
  # @param {Event} [e] - Event that triggered the opening of this modal.
  #
  # @method open
  # @memberof stout-ui/modal/ModalView#
  # @public
  ###
  open: (e) =>
    openPromise = e?.data.promise or new Promise()

    # Capture the activating component (button, etc.) if present.
    @activator = e?.data.activator

    #@render().then =>

    # If this modal isn't static, then attach an event listener so it's closed
    # when/if the user clicks on the backdrop.
    if not @static
      backdrop().once 'transition:out', =>
        @close()
        Promise.reject openPromise

    # Initiate the modal transition.
    Promise.resolve openPromise, @transitionIn(TRANS_IN_TIME)


    # Show the backdrop, making it inherit the modal's "static" state.
    backdrop().static = @static
    backdrop().transitionIn()

    openPromise
