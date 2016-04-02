buttonFactory = require '../../button'
Button        = require '../../button/Button'
ButtonView    = require '../../button/ButtonView'
Pane          = require '../../pane/Pane'
PaneView      = require '../../pane/PaneView'


document.addEventListener 'DOMContentLoaded', ->

  closeBtn = new ButtonView
    context: new Button
    label: 'Close PaneView'
    classes: 'btn-close-pane'
    type: 'primary'
    click: 'closePaneView'

  pane = new PaneView
    context: new Pane
    parent: document.body
    id: 'basic-pane'
    contents: closeBtn

  closeBtn.context.closePaneView = ->
    pane.transitionOut().then ->
      pane.width = 'full'
      pane.height = 'full'
      pane.root.style.top = ''
      pane.root.style.right = ''
      pane.root.style.bottom = ''
      pane.root.style.left = ''
    , (e) ->
      console.log 'got error', e

  pane.render().then -> pane.hide()

  buttonFactory
    label: 'Show PaneView'
    parent: '.ex.basic .controls'
    click: ->
      pane.transition = 'fade'
      pane.transitionIn()
  .render()


  for transition in ['fade', 'zoom', 'overlay']
    buttonFactory
      label: transition
      size: 'small'
      type: 'inverse'
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
    buttonFactory
      label: start
      size: 'small'
      type: 'inverse'
      parent: '.ex.overlay-starts .controls'
      click: ((st)->
          ->
            pane.transition = 'overlay'
            pane.start = st
            pane.transitionIn()
        )(start)
    .render()


  # --- Sizing ---

  buttonFactory
    label: 'Auto Size Width'
    size: 'small'
    type: 'inverse'
    parent: '.ex.sizing .controls'
    click: ->
      pane.root.style.left = 'auto'
      pane.root.style.right = '0'
      pane.width = 'auto'
      pane.transition = 'overlay'
      pane.start = 'right'
      pane.transitionIn()
  .render()

  buttonFactory
    label: '200px Height'
    size: 'small'
    type: 'inverse'
    parent: '.ex.sizing .controls'
    click: ->
      pane.height = 200
      pane.transition = 'overlay'
      pane.start = 'top'
      pane.transitionIn()
  .render()
