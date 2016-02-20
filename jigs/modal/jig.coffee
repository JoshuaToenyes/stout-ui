Button = require '../../button/Button'
backdrop = require '../../modal/backdrop'
Modal = require '../../modal/Modal'

window.backdrop = backdrop

document.addEventListener 'DOMContentLoaded', ->
  window.modal = m = new Modal
    parentEl: document.body
    contents: 'hello world!'
    static: false

  new Button
    label: 'Show Backdrop'
    parentEl: '.ex.basic .controls'
    click: ->
      backdrop().static = false
      backdrop().transitionIn()
  .render()

  new Button
    label: 'Show Modal Window'
    parentEl: '.ex.modal-window .controls'
    click: m.open
  .render()
