###*
# @overview Defines the generic Pane object which can be used for application
# window "panes" or modal windows, etc.
#
# @module stout-ui/pane/Pane
###

ComponentView = require '../component/ComponentView'
defaults      = require 'lodash/defaults'
Pane          = require './Pane'
template      = require './pane.template'
vars          = require '../vars'
View          =

# Load shared variables.
require '../vars/pane'


###*
# The class to add to the root pane container.
# @const
# @type string
# @private
###
PANE_CLS = vars.read 'pane/pane-class'


###*
# Default pane transition-in time.
# @const
# @type number
# @private
###
TRANS_IN_TIME = vars.readTime 'pane/pane-trans-in-time'


###*
# Default pane transition-out time.
# @const
# @type number
# @private
###
TRANS_OUT_TIME = vars.readTime 'pane/pane-trans-out-time'


###*
# The pane custom tag name.
# @type string
# @const
# @private
###
TAG_NAME = vars.readPrefixed 'pane/pane-tag'



###*
# Pane class which represents a generic pane for displaying content within
# the viewport.
#
# @param {Object} [init] - Initiation object.
#
# @exports stout-ui/pane/Pane
# @extends stout-ui/container/Container
# @constructor
###
module.exports = class PaneView extends ComponentView

  constructor: (init, events) ->
    defaults init, {template, tagName: TAG_NAME}
    super init, events
    @prefixedClasses.add PANE_CLS
    @syncProperty @context, 'transition start end width height'

    @on 'transition:in', ->
      @setDisplaySize()
      @setDisplayTransform()

    @on 'transition:out', -> 
      @setInitialTransform()

  # Clone shared view-model properties.
  @cloneProperty Pane, 'transition start end width height'


  ###*
  # Window resize event handler. It simply repositions the modal window and
  # its contents.
  #
  # @method _resizeHandler
  # @memberof stout-ui/modal/Modal#
  # @protected
  ###
  _resizeHandler: =>
    @setDisplaySize()


  ###*
  # Calculates the final sizes of the pane.
  #
  # @returns {Array<number>} Array in the form of `[width, height]`.
  #
  # @method calculateDisplaySize
  # @memberof stout-ui/modal/Modal#
  # @public
  ###
  calculateDisplaySize: ->
    h = @height
    w = @width

    content = @select '.' + @contentsContainerClass

    flash = @hidden and not @transitioning

    if flash then @show()
    #if content instanceof ComponentView then content.show()
    rect = content.getBoundingClientRect()
    if flash then @hide()

    if @height is 'auto' then h = rect.height
    if @width is 'auto' then w = rect.width

    if @height is 'full' then h = window.innerHeight
    if @width is 'full' then w = window.innerWidth

    [w, h]



  calculateZoomStartSize: ->
    # Get button bounding rectangle if an activator is registered, otherwise
    # open the modal from the center of the window.
    if @activator
      b = @activator.getBoundingClientRect()
    else
      b = width: 30, height: 30

    [b.width, b.height]


  ###*
  # Calculates the pane's starting size with an overlay transition.
  #
  ###
  calculateOverlayStartSize: ->
    @calculateDisplaySize()


  ###*
  # Calculates the start size of the pane.
  #
  # @returns {Array<number>} Array in the form of `[width, height]`.
  #
  # @method calculateStartSize
  # @memberof stout-ui/modal/Modal#
  # @public
  ###
  calculateStartSize: ->
    if @transition is 'zoom'
      @calculateZoomStartSize()
    else if @transition is 'overlay' or @transition is 'fade'
      @calculateOverlayStartSize()


  ###*
  # Calculates the final center of the pane, in pixels, relative to the
  # viewport.
  #
  # @returns {Array<number>} Array in the form of `[x, y]` coordinates.
  #
  # @method calculateDisplayCenter
  # @memberof stout-ui/pane/Pane#
  # @public
  ###
  calculateDisplayCenter: ->
    [window.innerWidth / 2, window.innerHeight / 2]


  ###*
  # Calculates the initial center of the pane, in pixels, relative to the
  # viewport.
  #
  # @returns {Array<number>} Array in the form of `[x, y]` coordinates.
  #
  # @method calculateInitialCenter
  # @memberof stout-ui/pane/Pane#
  # @public
  ###
  calculateInitialCenter: ->
    if @transition is 'fade'
      @calculateFadeStartCenter()
    else if @transition is 'zoom'
      @calculateZoomStartCenter()
    else if @transition is 'overlay'
      @calculateOverlayStartCenter()


  ###*
  # Calculates and returns final transformation parameters for when the pane
  # should be fully transitioned-in.
  #
  # @returns {Array<number>} Array of `matrix3d` CSS transformation parameters.
  #
  # @method calculateDisplayTransformParams
  # @memberof stout-ui/pane/Pane#
  # @public
  ###
  calculateDisplayTransformParams: ->
    [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]


  ###*
  # Calculates and returns initial transformation parameters for when the pane
  # should start opening.
  #
  # @returns {Array<number>} Array of `matrix3d` CSS transformation parameters.
  #
  # @method calculateInitialTransformParams
  # @memberof stout-ui/pane/Pane#
  # @public
  ###
  calculateInitialTransformParams: ->
    iz = @calculateStartSize()
    fz = @calculateDisplaySize()

    ic = @calculateInitialCenter()
    fc = @calculateDisplayCenter()

    sx = iz[0] / fz[0]
    sy = iz[1] / fz[1]
    tx = fc[0] - ic[0]
    ty = fc[1] - ic[1]

    [sx, 0, 0, 0, 0, sy, 0, 0, 0, 0, 1, 0, -tx, -ty, 0, 1]


  ###*
  # Calculates the "overlay" transition start center.
  #
  # @method calculateOverlayStartCenter
  # @memberof stout-ui/pane/Pane#
  # @public
  ###
  calculateOverlayStartCenter: ->
    [w, h] = @calculateDisplaySize()
    [x, y] = @calculateDisplayCenter()
    switch @start
      when null then @calculateZoomStartCenter()
      when 'top' then [w / 2, y - h]
      when 'right' then [x + w, h / 2]
      when 'bottom' then [w / 2, y + h]
      when 'left' then [x - w, h / 2]


  ###*
  # Calculates the "zoom" transition start center.
  #
  # @method calculateZoomStartCenter
  # @memberof stout-ui/pane/Pane#
  ###
  calculateZoomStartCenter: ->
    # Get button bounding rectangle if an activator is registered, otherwise
    # open the modal from the center of the window.
    if @activator
      b = @activator.getBoundingClientRect()
      [b.left + 0.5 * b.width, b.top + 0.5 * b.height]
    else
      @calculateFadeStartCenter()


  ###*
  # Calculates the center of the fade transition's start.
  #
  # @method calculateFadeStartCenter
  # @memberof stout-ui/pane/Pane#
  ###
  calculateFadeStartCenter: ->
    [window.innerWidth / 2, window.innerHeight / 2]


  ###*
  # Resets the pane's size and position.
  #
  # @method resetSizeAndPosition
  # @memberof stout-ui/pane/Pane#
  # @public
  ###
  resetSizeAndPosition: ->
    @root.style.width = "auto"
    @root.style.height = "auto"
    @root.style.transform = "none"


  ###*
  # Sets the initial transformation parameters of this pane.
  #
  # @method setInitialTransform
  # @memberof stout-ui/pane/Pane#
  # @public
  ###
  setInitialTransform: ->
    @setTransform @calculateInitialTransformParams()


  ###*
  # Sets the final-size of the pane.
  #
  # @method setDisplaySize
  # @memberof stout-ui/pane/Pane#
  # @public
  ###
  setDisplaySize: ->
    [w, h] = @calculateDisplaySize()
    @root.style.width = "#{w}px"
    @root.style.height = "#{h}px"


  ###*
  # Sets the final transformation parameters of this pane.
  #
  # @method setDisplayTransform
  # @memberof stout-ui/pane/Pane#
  # @public
  ###
  setDisplayTransform: ->
    @setTransform @calculateDisplayTransformParams()


  ###*
  # Sets pane transformation parameters.
  #
  # @param {Array<number>} params Array of `matrix3d` CSS transformation
  # parameters.
  #
  # @method setTransform
  # @memberof stout-ui/pane/Pane#
  # @public
  ###
  setTransform: (params) ->
    @root.style.transform = "matrix3d(#{params.join(',')})"
    if @transition is 'zoom'
      @root.style.transform += " translate3d(-50%, -50%, 0)"


  ###*
  # Transitions-in this pane.
  #
  # @method transitionIn
  # @memberof stout-ui/pane/Pane#
  # @public
  ###
  transitionIn: (time = TRANS_IN_TIME) ->
    @setPaneTransitionClasses()
    @resetSizeAndPosition()
    @setInitialTransform()
    super(time).then ->
      # When the window is resizes, reposition the modal and its contents.
      window.addEventListener 'resize', @_resizeHandler


  ###*
  # Transitions-out this pane.
  #
  # @method transitionOut
  # @memberof stout-ui/pane/Pane#
  ###
  transitionOut: (time = TRANS_OUT_TIME) ->
    @setPaneTransitionClasses()
    super(time).then ->
      window.removeEventListener 'resize', @_resizeHandler


  ###*
  # Sets the transition classes on the pane element.
  #
  # @method setPaneTransitionClasses
  # @memberof stout-ui/pane/Pane#
  ###
  setPaneTransitionClasses: ->
    @prefixedClasses.remove 'zoom overlay'
    @prefixedClasses.add @transition
    @prefixedClasses.remove 'start-top start-right start-bottom start-left'
    @prefixedClasses.remove 'end-top end-right end-bottom end-left'
    if @start then @prefixedClasses.add 'start-' + @start
    if @end then @prefixedClasses.add 'end-' + @end
