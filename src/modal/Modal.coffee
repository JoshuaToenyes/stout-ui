###*
# @overview Defines a basic modal window UI component.
# @module stout-ui/modal/Modal
###

Container = require '../container/Container'
template  = require './modal.template'
backdrop  = require './backdrop'
vars      = require '../vars'
animate   = require 'stout-client/animation/animate'
cubicInOut = require 'stout-client/easing/cubicInOut'
Promise    = require 'stout-core/promise/Promise'

# Load modal variables.
require '../vars/modal'


###*
# The common class name prefix
# @const
# @type string
# @private
###
PREFIX = vars.read 'common/prefix'


###*
# The class to add to the root modal container.
# @const
# @type string
# @private
###
MODAL_CLS = vars.read 'modal/modal-class'


###*
# The inner contents container class.
# @const
# @type string
# @private
###
CONTENTS_CLS = PREFIX + vars.read 'container/container-contents-class'


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



module.exports = class Modal extends Container

  ###*
  # MaskedTextInput constructor.
  #
  # @param {Object} [init] - Initiation object.
  #
  # @exports stout-ui/modal/Modal
  # @extends stout-ui/container/Container
  # @constructor
  ###
  constructor: (init = {}) ->
    super template, null, {renderOnChange: false}, init
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
  # Calculates the final sizes of the modal window.
  #
  # @returns {Array<number>} Array in the form of `[width, height]`.
  #
  # @method calculateFinalSize
  # @memberof stout-ui/modal/Modal#
  # @public
  ###
  calculateFinalSize: ->
    h = @height
    w = @width

    content = @select('.' + CONTENTS_CLS)

    flash = @hidden and not @transitioning

    if flash then @show()
    rect = content.getBoundingClientRect()
    if flash then @hide()

    if @height is 'auto' then h = rect.height
    if @width is 'auto' then w = rect.width

    [w, h]


  ###*
  # Calculates the initial sizes of the modal window.
  #
  # @returns {Array<number>} Array in the form of `[width, height]`.
  #
  # @method calculateInitialSize
  # @memberof stout-ui/modal/Modal#
  # @public
  ###
  calculateInitialSize: ->
    # Get button bounding rectangle if an activator is registered, otherwise
    # open the modal from the center of the window.
    if @_activator
      b = @_activator.getBoundingClientRect()
    else
      b = width: 30, height: 30

    [b.width, b.height]


  ###*
  # Calculates the final center of the modal window, in pixels, relative to the
  # viewport.
  #
  # @returns {Array<number>} Array in the form of `[x, y]` coordinates.
  #
  # @method calculateFinalCenter
  # @memberof stout-ui/modal/Modal#
  # @public
  ###
  calculateFinalCenter: ->
    H = window.innerHeight
    W = window.innerWidth
    [W / 2, H / 2]


  ###*
  # Calculates the initial center of the modal window, in pixels, relative to
  # the viewport.
  #
  # @returns {Array<number>} Array in the form of `[x, y]` coordinates.
  #
  # @method calculateInitialCenter
  # @memberof stout-ui/modal/Modal#
  # @public
  ###
  calculateInitialCenter: ->
    H = window.innerHeight
    W = window.innerWidth

    # Get button bounding rectangle if an activator is registered, otherwise
    # open the modal from the center of the window.
    if @_activator
      b = @_activator.getBoundingClientRect()
    else
      b = left: W / 2, width: 0, top: H / 2, height: 0

    [b.left + 0.5 * b.width, b.top + 0.5 * b.height]


  ###*
  # Calculates and returns final transformation parameters for when the modal
  # window should be fully open.
  #
  # @returns {Array<number>} Array of `matrix3d` CSS transformation parameters.
  #
  # @method calculateFinalTransformParams
  # @memberof stout-ui/modal/Modal#
  # @public
  ###
  calculateFinalTransformParams: ->
    [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]


  ###*
  # Calculates and returns initial transformation parameters for when the modal
  # window should start opening.
  #
  # @returns {Array<number>} Array of `matrix3d` CSS transformation parameters.
  #
  # @method calculateInitialTransformParams
  # @memberof stout-ui/modal/Modal#
  # @public
  ###
  calculateInitialTransformParams: ->
    iz = @calculateInitialSize()
    fz = @calculateFinalSize()

    ic = @calculateInitialCenter()
    fc = @calculateFinalCenter()

    sx = iz[0] / fz[0]
    sy = iz[1] / fz[1]
    tx = fc[0] - ic[0]
    ty = fc[1] - ic[1]

    [sx, 0, 0, 0, 0, sy, 0, 0, 0, 0, 1, 0, -tx, -ty, 0, 1]


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


  ###*
  # Resets the modal window's size and position.
  #
  # @method resetSizeAndPosition
  # @memberof stout-ui/modal/Modal#
  # @public
  ###
  resetSizeAndPosition: ->
    @root.style.width = "auto"
    @root.style.height = "auto"
    @root.style.transform = "none"


  ###*
  # Sets the initial transformation parameters of the modal window.
  #
  # @method setInitialTransform
  # @memberof stout-ui/modal/Modal#
  # @public
  ###
  setInitialTransform: ->
    @setTransform @calculateInitialTransformParams()


  ###*
  # Sets the final-size of the modal window.
  #
  # @method setFinalSize
  # @memberof stout-ui/modal/Modal#
  # @public
  ###
  setFinalSize: ->
    [w, h] = @calculateFinalSize()
    @root.style.width = "#{w}px"
    @root.style.height = "#{h}px"


  ###*
  # Sets the final transformation parameters of the modal window.
  #
  # @method setFinalTransform
  # @memberof stout-ui/modal/Modal#
  # @public
  ###
  setFinalTransform: ->
    @setTransform @calculateFinalTransformParams()


  ###*
  # Sets modal window transformation parameters.
  #
  # @param {Array<number>} params Array of `matrix3d` CSS transformation
  # parameters.
  #
  # @method setTransform
  # @memberof stout-ui/modal/Modal#
  # @public
  ###
  setTransform: (params) ->
    @root.style.transform = "matrix3d(#{params.join(',')}) translate3d(-50%, -50%, 0)"


  ###*
  # Transitions-in this modal window.
  #
  # @method transitionIn
  # @memberof stout-ui/modal/Modal#
  # @public
  ###
  transitionIn: (time, cb) ->
    @resetSizeAndPosition()
    @setFinalSize()
    @setInitialTransform()
    @once 'transition:in', ->
      @setFinalTransform()
    super(time, cb)


  ###*
  # Transitions-out this modal window.
  #
  # @method transitionOut
  # @memberof stout-ui/modal/Modal#
  # @public
  ###
  transitionOut: (time, cb) ->
    @once 'transition:out', ->
      @setInitialTransform()
    super(time, cb)
