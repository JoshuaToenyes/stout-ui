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


  @property 'windowClassName',
    const: true
    get: -> @prefix + MODAL_WINDOW_CLS


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


  _getActivatorBounds: (e) ->
    # Get button bounding rect.
    bounds = e.source.el.getBoundingClientRect()

    # Calculate starts.
    left = bounds.left / window.innerWidth * 100 + '%'
    right = 100 - bounds.right / window.innerWidth * 100 + '%'
    top = bounds.top / window.innerHeight * 100 + '%'
    bottom = 100 - bounds.bottom / window.innerHeight * 100 + '%'

    [top, right, bottom, left]

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

    console.log @objectify()

    @render()

    [top, right, bottom, left] = @_activatorBounds =  @_getActivatorBounds(e)

    @el.style.left = left
    @el.style.right = right
    @el.style.top = top
    @el.style.bottom = bottom

    animate @el, {top: '10%', right: '10%', bottom: '10%', left: '10%'}, TRANS_IN_TIME, require 'stout-client/easing/cubicInOut'

    # --- animate scale contents ---
    # start = bounds.right - bounds.left
    # end = 0.8 * window.innerWidth
    # scale = start / end
    contents = @select('.ui-container-contents')
    #contents.style.transform = "scale(#{scale})"

    contents.style.left = '10%'
    contents.style.right = '10%'
    contents.style.top = '10%'
    contents.style.bottom = '10%'

    # setTimeout ->
    #   animate contents, {scale: 1}, TRANS_IN_TIME / 2, require 'stout-client/easing/cubicInOut'
    # , TRANS_IN_TIME / 2

    if not @static then backdrop().on 'transition:out', @close, @
    @transitionIn TRANS_IN_TIME

    backdrop().static = @static
    backdrop().transitionIn()


  close: (cb) ->
    backdrop().transitionOut()

    [top, right, bottom, left] = @_activatorBounds

    animate @el, {top, right, bottom, left}, TRANS_OUT_TIME, require 'stout-client/easing/cubicInOut'

    @transitionOut TRANS_OUT_TIME, => @destroy()
