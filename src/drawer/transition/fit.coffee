###*
# @overview Defines the pane fade transition.
# @module stout-ui/drawer/transition/fit
###
push = require './push'
Promise = require 'stout-core/promise/Promise'


oppositeSide = (side) ->
  switch side
    when 'left' then 'right'
    when 'right' then 'left'


###*
# The pane fade transition fades the pane in-and-out. The JavaScript handles
# the translation positioning of the pane, while CSS handles the actual
# transition and fading effect.
#
# @exports stout-ui/drawer/transition/fit
###
module.exports =

  ###*
  # Sets-up the transition-out. This method is essentially a no-op.
  ###
  setupIn: ->
    push.setupIn.call(@).then ({width, height}) =>
      @container.style['padding-' + oppositeSide(@side)] = '0'


  ###*
  # Sets-up the transition-out. This method is essentially a no-op.
  ###
  setupOut: push.setupOut


  in: ->
    push.in.call(@).then ({width, height}) =>
      @container.style['padding-' + oppositeSide(@side)] = "#{width}px"


  out: ->
    push.out.call(@).then () =>
      @container.style['padding-' + oppositeSide(@side)] = '0'


  afterIn: push.afterIn


  afterOut: push.afterOut
