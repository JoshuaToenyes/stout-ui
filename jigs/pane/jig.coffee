Button = require '../../button/Button'
Pane = require '../../pane/Pane'


document.addEventListener 'DOMContentLoaded', ->

  closeButton = new Button
    label: 'Close Pane'
    classes: 'btn-close-pane'
    style: 'primary'

  pane = new Pane
    parent: document.body
    id: 'basic-pane'
    contents: closeButton

  closeButton.click = ->
    pane.transitionOut null, ->
      pane.width = 'full'
      pane.height = 'full'
      pane.root.style.top = ''
      pane.root.style.right = ''
      pane.root.style.bottom = ''
      pane.root.style.left = ''

  pane.hide()
  pane.render()

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


  # --- Sizing ---

  new Button
    label: 'Auto Size Width'
    size: 'small'
    style: 'inverse'
    parent: '.ex.sizing .controls'
    click: ->
      pane.root.style.left = 'auto'
      pane.root.style.right = '0'
      pane.width = 'auto'
      pane.transition = 'overlay'
      pane.start = 'right'
      pane.transitionIn()
  .render()

  new Button
    label: '200px Height'
    size: 'small'
    style: 'inverse'
    parent: '.ex.sizing .controls'
    click: ->
      pane.height = 200
      pane.transition = 'overlay'
      pane.start = 'top'
      pane.transitionIn()
  .render()
