###*
# @overview Defines the zoom overlay transition.
# @module stout-ui/pane/zoom
###
Promise = require 'stout-core/promise/Promise'


###*
# Calculates the initial (zoomed-out) size of the pane.
#
# @returns {Array.<number>} Array of the form `[width, height]`.
###
calcSize = ->
  if @activator
    b = @activator.getBoundingClientRect()
  else
    b = width: 30, height: 30
  [b.width, b.height]


###*
# Calculates the initial (zoomed-out) center position of the pane.
#
# @returns {Array.<number>} Array of the form `[x, y]`.
###
calcCenter = ->
  if @activator
    b = @activator.getBoundingClientRect()
    [b.left + 0.5 * b.width, b.top + 0.5 * b.height]
  else
    [window.innerWidth / 2, window.innerHeight / 2]


###*
# Positions the pane off-screen.
#
# @function
# @inner
###
positionOut = ->
  @contents.getRenderedDimensions().then ({width, height}) =>
    W = window.innerWidth
    H = window.innerHeight

    iz = calcSize.call @
    fz = [null, null]

    ic = calcCenter.call @
    fc = [W / 2, H / 2]

    switch @width
      when 'full' then fz[0] = W
      when 'auto' then fz[0] = width
      else fz[0] = @width

    switch @height
      when 'full' then fz[1] = H
      when 'auto' then fz[1] = height
      else fz[1] = @height

    sx = iz[0] / fz[0]
    sy = iz[1] / fz[1]
    tx = fc[0] - ic[0]
    ty = fc[1] - ic[1]

    p = [sx, 0, 0, 0, 0, sy, 0, 0, 0, 0, 1, 0, -tx, -ty, 0, 1]

    @root.style.transform = "
      matrix3d(#{p.join(',')})
      translate3d(-50%, -50%, 0)"



###*
# The pane overlay transition animates the pane in-and-out with a zoom-effect.
# The JavaScript handles the translation positioning and scaling of the pane,
# while CSS handles the actual transition and fading effect.
#
# @exports stout-ui/pane/zoom
###
module.exports =

  ###*
  # Translates the pane in.
  ###
  in: ->
    p = [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]
    @root.style.transform = "
      matrix3d(#{p.join(',')})
      translate3d(-50%, -50%, 0)"


  ###*
  # Translates the pane out.
  ###
  out: positionOut


  ###*
  # Sets-up the transition-in.
  ###
  setupIn: positionOut


  ###*
  # Sets-up the transition-out. This method is essentially a no-op.
  ###
  setupOut: -> Promise.noop()
