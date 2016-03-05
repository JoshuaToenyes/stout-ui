Button = require '../../button/Button'

#require './example.sass'
#require 'button/button.sass'

# atomIcon = require './atom-icon.svg'

window.onload = ->

  # Size examples.
  for size in ['tiny', 'small', 'normal', 'large', 'huge', 'massive']
    new Button
      label: 'Make Reservation'
      parent: '.size-' + size
      size: size
    .render()


  # Invers button style example.
  new Button
    label: 'Confirm Order'
    parent: '.inverse'
    style: 'inverse'
  .render()


  # Flat button styles
  for style in ['normal', 'primary', 'inverse', 'warn', 'danger']

    new Button
      label: style + ' flat button'
      parent: ".#{style}-flat"
      style: style + '-flat'
    .render()



  # Primary button style example.
  new Button
    label: 'Place Order'
    parent: '.primary'
    style: 'primary'
  .render()



  # Warn button style example.
  new Button
    label: 'Launch Missile'
    parent: '.warn'
    style: 'warn'
  .render()


  # Danger button style example.
  new Button
    label: 'Delete Everything'
    parent: '.danger'
    style: 'danger'
  .render()


  # Disabled button example.
  for style in ['normal', 'primary', 'inverse']

    disabledButton = new Button
      label: 'Button Disabled'
      parent: ".disabled-#{style} .subject"
      style: style
    .render().disable()

    new Button
      label: 'Enable'
      size: 'tiny'
      parent: ".disabled-#{style} .controls"
      click: ((db) ->
        -> db.enable()
      )(disabledButton)
    .render()

    new Button
      label: 'Disable'
      size: 'tiny'
      parent: ".disabled-#{style} .controls"
      click: ((db) ->
        -> db.disable()
      )(disabledButton)
    .render()



  # Show-hide example buttons.
  showButtonEx = new Button
    label: 'Reveal Example'
    parent: '.show-hide .subject'
    style: 'primary'
    classes: 'show-hide-subject'
  .render()

  new Button
    label: 'Show'
    size: 'tiny'
    parent: '.show-hide .controls'
    classes: 'show-button'
    click: ->
      showButtonEx.show()
  .render()

  new Button
    label: 'Hide'
    size: 'tiny'
    parent: '.show-hide .controls'
    classes: 'hide-button'
    click: ->
      showButtonEx.hide()
  .render()

# btop = new Button
#   label: 'Top Label'
#   parent: demoEl
#   svgIcon: atomIcon
#   iconPosition: 'top'
#
# bbottom = new Button
#   label: 'Bottom Label'
#   parent: demoEl
#   svgIcon: atomIcon
#   iconPosition: 'bottom'
#
# bleft   = new Button
#   label: 'Left Label'
#   parent: demoEl
#   svgIcon: atomIcon
#   iconPosition: 'left'
#
# bright  = new Button
#   label: 'Right Label'
#   parent: demoEl
#   svgIcon: atomIcon
#   iconPosition: 'right'
#
# bnolabel  = new Button
#   parent: demoEl
#   svgIcon: atomIcon


# btop.render()
# bbottom.render()
# bleft.render()
# bright.render()
# bnolabel.render()
