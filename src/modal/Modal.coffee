###*
# @overview Defines a basic modal window UI component.
# @module stout-ui/modal/Modal
###

Container = require '../container/Container'
template  = require './modal.template'
backdrop  = require './backdrop'
vars      = require '../vars'
animate   = require 'stout-client/animation/animate'


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
# The class to add to the modal window container.
# @const
# @type string
# @private
###
MODAL_WINDOW_CLS = vars.read 'modal/modal-window-class'


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
    default: 500


  @property 'height',
    default: 400


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
  # Calculates the relative position (in percent) of the passed element.
  #
  # @param {HTMLElement} el - The element which should have it's relative
  # bounds calculated.
  ###
  _calcActivatorBounds: () ->
    # Get button bounding rect.
    bounds = @_activator.getBoundingClientRect()

    W = window.innerWidth
    H = window.innerHeight

    # Calculate starts.
    left = bounds.left / W * 100 + '%'
    right = 100 - bounds.right / W * 100 + '%'
    top = bounds.top / H * 100 + '%'
    bottom = 100 - bounds.bottom / H * 100 + '%'

    {top, right, bottom, left}


  ###*
  # Calculates a relative position (in percent) within the window, given the
  # maximum window width and height.
  #
  # @returns {Object} Object with top, right, bottom, and left keys set with
  # calculated percentages.
  #
  # @method _calcRelativePosition
  # @memberof stout-ui/modal/Modal#
  # @private
  ###
  _calcRelativePostion: ->
    H = window.innerHeight
    W = window.innerWidth
    top = bottom = Math.min(100, (H - @height) / H / 2 * 100 ) + '%'
    left = right = Math.min(100, (W - @width) / W / 2 * 100 ) + '%'
    {top, right, bottom, left}


  ###*
  # Positions the content window immediately.
  #
  ###
  _positionContents: ->
    contents = @select('.ui-container-contents')
    for p, v of @_calcRelativePostion()
      contents.style[p] = v


  ###*
  # Positions the modal window for opening.
  ###
  _positionForOpen: ->
    console.log @_calcActivatorBounds()
    for p, v of @_calcActivatorBounds()
      @el.style[p] = v


  ##
  # Opens the modal window. Optionally, a title and modal contents may be
  # passed to this method which will override the existing title and modal.
  # This method is essentially equivalent to calling `#render()` followed by
  # `#show()`.
  #
  # @param {string} [title] - The modal title.
  #
  # @param {string|HTMLElement|ClientView} [contents] - The modal contents.
  #
  # @todo This should return a composed promise.
  #
  # @method open
  # @public
  open: (e) =>
    @render()

    # Capture the activating component (button, etc.) if present.
    @_activator = e?.source.el

    # Position the modal for its opening animation.
    @_positionForOpen()

    # Calculate the relative position of where the modal window animation
    # should end. The calculated positin is in percent and measures from each
    # edge of the screen (top, right, bottom, left).
    pos = @_calcRelativePostion()

    # Initiate the modal animation to it's ending position.
    animate @el, pos, TRANS_IN_TIME, require 'stout-client/easing/cubicInOut'

    # Immediately position the modal contents.
    @_positionContents()

    if not @static then backdrop().on 'transition:out', @close, @

    # Initiate the modal transition.
    @transitionIn TRANS_IN_TIME

    backdrop().static = @static
    backdrop().transitionIn()


  close: (cb) ->
    backdrop().transitionOut()

    pos = @_calcActivatorBounds()

    animate @el, pos, TRANS_OUT_TIME, require 'stout-client/easing/cubicInOut'

    @transitionOut TRANS_OUT_TIME, => @destroy()
