Button = require '../../button/Button'
Pane = require '../../pane/Pane'


document.addEventListener 'DOMContentLoaded', ->

  closeButton = new Button
    label: 'Close Pane'
    classes: 'btn-close-pane'

  pane = new Pane
    parent: document.body
    id: 'basic-pane'
    contents: closeButton
  pane.render()
  pane.hide()

  closeButton.click = -> pane.transitionOut()

  new Button
    label: 'Show Pane'
    parent: '.ex.basic .controls'
    click: ->
      pane.transition = 'fade'
      pane.transitionIn()
  .render()


  for transition in ['fade', 'zoom', 'overlay']
    new Button
      label: transition
      size: 'small'
      style: 'inverse'
      parent: '.ex.transitions .controls'
      click: ((t)->
          (e) ->
            pane.activator = e.source.root
            pane.transition = t
            pane.start = 'right'
            pane.transitionIn()
        )(transition)
    .render()


  for start in ['top', 'right', 'bottom', 'left']
    new Button
      label: start
      size: 'small'
      style: 'inverse'
      parent: '.ex.overlay-starts .controls'
      click: ((st)->
          ->
            pane.transition = 'overlay'
            pane.start = st
            pane.transitionIn()
        )(start)
    .render()
