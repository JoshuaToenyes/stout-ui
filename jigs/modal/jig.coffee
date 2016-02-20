Button = require '../../button/Button'
backdrop = require '../../modal/backdrop'

window.backdrop = backdrop

window.onload = ->
  new Button
    label: 'Show Backdrop'
    parentEl: '.ex.basic .controls'
    size: 'small'
    click: ->
      backdrop().static = false
      backdrop().transitionIn()
  .render()
