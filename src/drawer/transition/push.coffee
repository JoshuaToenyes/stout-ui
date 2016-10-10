###*
# @overview Defines the drawer "push" transition.
# @module stout-ui/drawer/transition/push
###
Promise = require 'stout-core/promise/Promise'



###*
# Sets-up the drawer position and styling before an animation begins.
#
# @param {string} dir - The animation direction, "in" or "out".
#
# @function setup
###
setup = (dir) ->
  # Set the width and height based on the configured "side" where the drawer
  # should open. Drawer sizing should be adjusted by modifying the content.
  switch @side
    when 'top', 'bottom'
      @height = 'auto'
      @width = 'full'
      @root.style.left = '0'
      drawerDim = 'height'
    when 'left', 'right'
      @height = 'full'
      @width = 'auto'
      @root.style.top = '0'
      drawerDim = 'width'


  @__drawerScrollListener = =>
    @root.style.top = "#{window.pageYOffset}px"


  @getRenderedDimensions().then (d) =>
    if dir is 'in'
      @root.style[s] = 'auto' for s in ['top', 'right', 'bottom', 'left']
      @container.style[s] = 'auto' for s in ['top', 'right', 'bottom', 'left']
      @_setDrawerStateClasses 'opening'
    else
      @_setDrawerStateClasses 'closing'

    if @side in ['left', 'right']
      @__drawerScrollListener()
      window.addEventListener 'scroll', @__drawerScrollListener

    @root.style[@side] = "-#{d[drawerDim]}px"

    if dir is 'in'
      @container.style[@side] = '0'
      if @side is 'bottom'
        @root.style.position = 'fixed'
      else
        @root.style.position = ''
      @fire 'opening'
    else
      @fire 'closing'

    return d



###*
#
#
# @exports stout-ui/drawer/transition/push
###
module.exports = push =

  ###*
  # Sets-up the drawer position before the "in" animation begins.
  #
  # @function setupIn
  ###
  setupIn: ->
    setup.call @, 'in'


  ###*
  # Sets-up the drawer position before the "out" animation begins.
  #
  # @function setupOut
  ###
  setupOut: ->
    setup.call @, 'out'


  ###*
  # Shifts the drawer container (left, right, up, or down) to slide-in the drawer.
  # This effectively "pushes" some of the target container out-of-view to
  # accommodate the drawer.
  #
  # @function in
  ###
  in: ->
    @getRenderedDimensions().then ({width, height}) =>
      switch @side
        when 'top', 'bottom'
          translateDim = height
        when 'left', 'right'
          translateDim = width
      @container.style[@side] = "#{translateDim}px"
      @root.style[@side] = "-#{translateDim}px"
      {width, height}


  ###*
  # Shifts the drawer container back (left, right, up, or down) to slide-out the
  # drawer. This effectively "pulls" back the target container to hide the drawer.
  #
  # @function pullDrawerContainer
  ###
  out: ->
    @container.style[@side] = '0'
    Promise.fulfilled()


  ###*
  # Positions the drawer after the "in" animation is complete.
  #
  # @function afterIn
  ###
  afterIn: ->
    if @side in ['left', 'right']
      @root.style.top = '0'
    @root.style[@side] = '0'
    window.removeEventListener 'scroll', @__drawerScrollListener


  ###*
  # Positions the drawer after the "out" animation is complete.
  #
  # @function afterIn
  ###
  afterOut: ->
    window.removeEventListener 'scroll', @__drawerScrollListener
