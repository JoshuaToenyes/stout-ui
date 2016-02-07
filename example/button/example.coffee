Button = require 'stout/ui/button/Button'

require './example.sass'
require 'button/button.sass'

# atomIcon = require './atom-icon.svg'


# Size examples.
for size in ['tiny', 'small', 'normal', 'large', 'huge', 'massive']
  new Button
    label: 'Make Reservation'
    parentEl: '.size-' + size
    size: size
  .render()


# Primary button style example.
new Button
  label: 'Place Order'
  parentEl: '.primary'
  style: 'primary'
.render()


# Disabled button example.
for style in ['normal', 'primary']

  disabledButton = new Button
    label: 'Button Disabled'
    parentEl: ".disabled-#{style} .subject"
    style: style
  .render().disable()

  new Button
    label: 'Enable'
    size: 'tiny'
    parentEl: ".disabled-#{style} .controls"
    click: ((db) ->
      -> db.enable()
    )(disabledButton)
  .render()

  new Button
    label: 'Disable'
    size: 'tiny'
    parentEl: ".disabled-#{style} .controls"
    click: ((db) ->
      -> db.disable()
    )(disabledButton)
  .render()



# Show-hide example buttons.
showButtonEx = new Button
  label: 'Reveal Example'
  parentEl: '.show-hide .subject'
  style: 'primary'
  classes: 'show-hide-subject'
.render()

new Button
  label: 'Show'
  size: 'tiny'
  parentEl: '.show-hide .controls'
  classes: 'show-button'
  click: ->
    showButtonEx.show()
.render()

new Button
  label: 'Hide'
  size: 'tiny'
  parentEl: '.show-hide .controls'
  classes: 'hide-button'
  click: ->
    showButtonEx.hide()
.render()

# btop = new Button
#   label: 'Top Label'
#   parentEl: demoEl
#   svgIcon: atomIcon
#   iconPosition: 'top'
#
# bbottom = new Button
#   label: 'Bottom Label'
#   parentEl: demoEl
#   svgIcon: atomIcon
#   iconPosition: 'bottom'
#
# bleft   = new Button
#   label: 'Left Label'
#   parentEl: demoEl
#   svgIcon: atomIcon
#   iconPosition: 'left'
#
# bright  = new Button
#   label: 'Right Label'
#   parentEl: demoEl
#   svgIcon: atomIcon
#   iconPosition: 'right'
#
# bnolabel  = new Button
#   parentEl: demoEl
#   svgIcon: atomIcon


# btop.render()
# bbottom.render()
# bleft.render()
# bright.render()
# bnolabel.render()
