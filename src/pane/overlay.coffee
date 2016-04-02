###*
# @overview Defines the pane overlay transition.
# @module stout-ui/pane/overlay
###
Promise = require 'stout-core/promise/Promise'


###*
# Calculates the off-screen position x and y coordinates from the display's
# top-left corner for the transition.
#
# @param {number} w - The contents width.
#
# @param {number} h - The contents height.
#
# @returns {Array.<number>} An array of coordinates in the form `[x, y]` to
# position the pane.
#
# @function
# @inner
###
calcOffscreen = (w, h) ->
  W = window.innerWidth
  H = window.innerHeight

  switch @width
    when 'full' then w = W
    when 'auto' then w = w
    else w = @width

  switch @height
    when 'full' then h = H
    when 'auto' then h = h
    else h = @height

  # Correct for non-top-left positioned panes.
  if @root.style.right then W = w
  if @root.style.bottom then H = h

  switch (@start or 'right')
    when 'top' then [0, -h]
    when 'right' then [W, 0]
    when 'bottom' then [0, H]
    when 'left' then [-w, 0]


###*
# Positions the pane off-screen.
#
# @function
# @inner
###
positionOut = ->
  @contents.getRenderedDimensions().then ({width, height}) =>
    [tx, ty] = calcOffscreen.call @, width, height
    p = [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, tx, ty, 0, 1]
    @root.style.transform = "matrix3d(#{p.join(',')})"



###*
# The pane overlay transition animates the pane in-and-out in a sliding overlay
# style. The JavaScript handles the translation positioning of the pane, while
# CSS handles the actual transition and fading effect.
#
# @exports stout-ui/pane/overlay
###
module.exports =

  ###*
  # Translates the pane in.
  ###
  in: ->
    p = [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]
    @root.style.transform = "matrix3d(#{p.join(',')})"


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
