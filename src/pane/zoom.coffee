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
    [b.left, b.top]
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
      when 'auto' then fz[0] = Math.min(width, W)
      else fz[0] = @width

    switch @height
      when 'full' then fz[1] = H
      when 'auto' then fz[1] = height
      else fz[1] = @height

    if fz[0] < 1 then fz[0] *= W
    if fz[1] < 1 then fz[1] *= H

    sx = iz[0] / fz[0]
    sy = iz[1] / fz[1]
    tx = (fc[0] + (W - fz[0]) / 2) - ic[0]
    ty = (fc[1] + (H - fz[1]) / 2) - ic[1]

    tx -= W / 2
    ty -= H / 2

    p = [sx, 0, 0, 0, 0, sy, 0, 0, 0, 0, 1, 0, -tx, -ty, 0, 1]

    @root.style.transform = "matrix3d(#{p.join(',')})"


applyFullSizeTransform = ->
  p = [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]
  @root.style.transform = "matrix3d(#{p.join(',')})"


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
  in: applyFullSizeTransform


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
  setupOut: ->
    applyFullSizeTransform.call(@)
    Promise.fulfilled()
