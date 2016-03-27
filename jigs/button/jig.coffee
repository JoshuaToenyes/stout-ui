Interactive = require '../../interactive/Interactive'
ButtonView  = require '../../button/ButtonView'


window.onload = ->

  # Size examples.
  for size in ['tiny', 'small', 'normal', 'large', 'huge', 'massive']
    new ButtonView
      context: new Interactive
      contents: 'Make Reservation'
      parent: '.size-' + size
      size: size
    .render().then (v) ->
      console.log 'rendered!'
    .error (e) ->
      console.error 'Failed to render button: ', e


  # Invers button style example.
  new ButtonView
    context: new Interactive
    contents: 'Confirm Order'
    parent: '.inverse'
    type: 'inverse'
  .render()


  # Flat button styles
  for style in ['normal', 'primary', 'inverse', 'warn', 'danger']

    new ButtonView
      context: new Interactive
      contents: style + ' flat button'
      parent: ".#{style}-flat"
      type: style + '-flat'
    .render()



  # Primary button style example.
  new ButtonView
    context: new Interactive
    contents: 'Place Order'
    parent: '.primary'
    type: 'primary'
  .render()



  # Warn button style example.
  new ButtonView
    context: new Interactive
    contents: 'Launch Missile'
    parent: '.warn'
    type: 'warn'
  .render()


  # Danger button style example.
  new ButtonView
    context: new Interactive
    contents: 'Delete Everything'
    parent: '.danger'
    type: 'danger'
  .render()


  # Disabled button example.
  for style in ['normal', 'primary', 'inverse']

    disabledButton = new ButtonView
      context: new Interactive
      contents: 'Button Disabled'
      parent: ".disabled-#{style} .subject"
      type: style
    disabledButton.disable().render()


    new ButtonView
      context: new Interactive
      contents: 'Enable'
      size: 'tiny'
      parent: ".disabled-#{style} .controls"
      click: ((db) ->
        -> db.enable()
      )(disabledButton)
    .render()

    new ButtonView
      context: new Interactive
      contents: 'Disable'
      size: 'tiny'
      parent: ".disabled-#{style} .controls"
      tap: -> console.log 'tapped!'
      click: ((db) ->
        -> db.disable()
      )(disabledButton)
    .render()



  # Show-hide example buttons.
  showButtonEx = new ButtonView
    context: new Interactive
    contents: 'Reveal Example'
    parent: '.show-hide .subject'
    type: 'primary'
    classes: 'show-hide-subject'
  showButtonEx.render()

  new ButtonView
    context: new Interactive
    contents: 'Show'
    size: 'tiny'
    parent: '.show-hide .controls'
    classes: 'show-button'
    click: ->
      showButtonEx.show()
  .render()

  new ButtonView
    context: new Interactive
    contents: 'Hide'
    size: 'tiny'
    parent: '.show-hide .controls'
    classes: 'hide-button'
    click: ->
      showButtonEx.hide()
  .render()
