###*
# @overview Defines the generic Pane object which can be used for application
# window "panes" or modal windows, etc.
#
# @module stout-ui/pane/Pane
###

Container = require '../container/Container'
template  = require './pane.template'
vars      = require '../vars'

# Load shared variables.
require '../vars/pane'

###*
# The inner contents container class.
# @const
# @type string
# @private
###
CONTENTS_CLS = vars.readPrefixed 'container/container-contents-class'


###*
# The class to add to the root pane container.
# @const
# @type string
# @private
###
PANE_CLS = vars.read 'pane/pane-class'



module.exports = class Pane extends Container

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
  constructor: (init = {}) ->
    super template, null, {renderOnChange: false}, init
    @prefixedClasses.add PANE_CLS


  ###*
  # Transition type.
  #
  # @member transition
  # @memberof stout-ui/pane/Pane#
  # @public
  ###
  @property 'transition',
    default: 'overlay'
    values: [
      'zoom'
      'overlay'
    ]


  ###*
  # Transition origin, e.g. where the pane originates-from when it
  # transitions-in. Only valid for `overlay` transition type.
  #
  # @member origin
  # @memberof stout-ui/pane/Pane#
  # @public
  ###
  @property 'origin',
    values: [
      null
      'top'
      'right'
      'bottom'
      'left'
    ]


  ###*
  # Transition destination, e.g. where the pane animates-to when it
  # transitions-out. Only valid for `overlay` transition type.
  #
  # @member destination
  # @memberof stout-ui/pane/Pane#
  # @public
  ###
  @property 'destination',
    values: [
      null
      'top'
      'right'
      'bottom'
      'left'
    ]


  ###*
  # Calculates the final sizes of the pane.
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
  # Calculates the initial sizes of the pane.
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
  # Calculates the final center of the pane, in pixels, relative to the
  # viewport.
  #
  # @returns {Array<number>} Array in the form of `[x, y]` coordinates.
  #
  # @method calculateFinalCenter
  # @memberof stout-ui/pane/Pane#
  # @public
  ###
  calculateFinalCenter: ->
    H = window.innerHeight
    W = window.innerWidth
    [W / 2, H / 2]


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
  # Calculates and returns final transformation parameters for when the pane
  # should be fully transitioned-in.
  #
  # @returns {Array<number>} Array of `matrix3d` CSS transformation parameters.
  #
  # @method calculateFinalTransformParams
  # @memberof stout-ui/pane/Pane#
  # @public
  ###
  calculateFinalTransformParams: ->
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
    iz = @calculateInitialSize()
    fz = @calculateFinalSize()

    ic = @calculateInitialCenter()
    fc = @calculateFinalCenter()

    sx = iz[0] / fz[0]
    sy = iz[1] / fz[1]
    tx = fc[0] - ic[0]
    ty = fc[1] - ic[1]

    [sx, 0, 0, 0, 0, sy, 0, 0, 0, 0, 1, 0, -tx, -ty, 0, 1]


  render: ->
    r = super()
    @prefixedClasses.add @transition
    if @origin then @prefixedClasses.add 'origin-' + @origin
    if @destination then @prefixedClasses.add 'destination-' + @destination
    r


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
  # @method setFinalSize
  # @memberof stout-ui/pane/Pane#
  # @public
  ###
  setFinalSize: ->
    [w, h] = @calculateFinalSize()
    @root.style.width = "#{w}px"
    @root.style.height = "#{h}px"


  ###*
  # Sets the final transformation parameters of this pane.
  #
  # @method setFinalTransform
  # @memberof stout-ui/pane/Pane#
  # @public
  ###
  setFinalTransform: ->
    @setTransform @calculateFinalTransformParams()


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
    @root.style.transform = "matrix3d(#{params.join(',')}) translate3d(-50%, -50%, 0)"


  ###*
  # Transitions-in this pane.
  #
  # @method transitionIn
  # @memberof stout-ui/pane/Pane#
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
  # Transitions-out this pane.
  #
  # @method transitionOut
  # @memberof stout-ui/pane/Pane#
  # @public
  ###
  transitionOut: (time, cb) ->
    @once 'transition:out', ->
      @setInitialTransform()
    super(time, cb)
