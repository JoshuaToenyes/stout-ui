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
  # Calculates the relative position (in percent) of the passed element.
  #
  # @param {HTMLElement} el - The element which should have it's relative
  # bounds calculated.
  ###
  _calcActivatorBounds: () ->
    W = window.innerWidth
    H = window.innerHeight

    # Get button bounding rectangle if an activator is registered, otherwise
    # open the modal from the center of the window.
    if @_activator
      bounds = @_activator.getBoundingClientRect()
    else
      bounds = left: W / 2, right: W / 2, top: H / 2, bottom: H / 2

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

    h = @height
    w = @width

    # Captures the size of the content
    content = @select('.' + CONTENTS_CLS)

    content.style.position = 'absolute'
    content.style.top = ''
    content.style.right = ''
    content.style.bottom = ''
    content.style.left = ''

    rect = content.getBoundingClientRect()
    content.style.position = 'fixed'

    if @height is 'auto'
      h = rect.height

    if @width is 'auto'
      w = rect.width

    top = bottom = Math.max(0, (H - h) / H / 2 * 100 ) + '%'
    left = right = Math.max(0, (W - w) / W / 2 * 100 ) + '%'
    {top, right, bottom, left}


  ###*
  # Positions the contents container.
  #
  # @method _positionContents
  # @memberof stout-ui/modal/Modal#
  # @protected
  ###
  _positionContents: ->
    @_positionModalElement @select('.' + CONTENTS_CLS)


  ###*
  # Positions the modal window for opening.
  #
  # @method _positionForOpen
  # @memberof stout-ui/modal/Modal#
  # @protected
  ###
  _positionForOpen: ->
    for p, v of @_calcActivatorBounds()
      @root.style[p] = v


  ###*
  # This method positions the modal window and/or it's contents.
  #
  # @param {HTMLElement} [el] - The element to position. If nothing is passed
  # it will position the modal window and it's content container.
  #
  # @method _positionModalElement
  # @memberof stout-ui/modal/Modal#
  # @protected
  ###
  _positionModalElement: (el) ->
    if not el
      @_positionModalElement @root
      @_positionModalElement @select('.' + CONTENTS_CLS)
    else
      for p, v of @_calcRelativePostion()
        el.style[p] = v


  ###*
  # Window resize event handler. It simply repositions the modal window and
  # its contents.
  #
  # @method _resizeHandler
  # @memberof stout-ui/modal/Modal#
  # @protected
  ###
  _resizeHandler: =>
    @_positionModalElement()


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

    # Initiate the modal animation to it's ending position.
    #animate @root, pos, TRANS_IN_TIME, cubicInOut

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



  transitionIn: (time, cb) ->
    pos = @_calcRelativePostion()
    @once 'transition:in', ->
      # Calculate the relative position of where the modal window animation
      # should end. The calculated position is in percent and measures from each
      # edge of the screen (top, right, bottom, left).
      @root.style.top = pos.top
      @root.style.right = pos.right
      @root.style.bottom = pos.bottom
      @root.style.left = pos.left

    super(time, cb)

    # Position the modal for its opening animation.
    @_positionForOpen()
    @_positionContents()


  ###*
  # Closes this modal window.
  #
  #
  # @memberof stout-ui/modal/Modal#
  # @public
  ###
  close: ->
    closePromise = new Promise()

    pos = @_calcActivatorBounds()

    backdrop().transitionOut()

    setTimeout =>
      @root.style.top = pos.top
      @root.style.right = pos.right
      @root.style.bottom = pos.bottom
      @root.style.left = pos.left
    , 0

    window.removeEventListener 'resize', @_resizeHandler

    @transitionOut TRANS_OUT_TIME, =>
      Promise.resolve closePromise
      #@destroy()
