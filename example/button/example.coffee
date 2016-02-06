Button = require 'stout/ui/button/Button'

require './example.sass'
require 'button/button.sass'

# atomIcon = require './atom-icon.svg'
demoEl = document.getElementById('demo')

new Button
  label: 'Make Reservation'
  parentEl: demoEl
  size: 'tiny'
.render()

new Button
  label: 'Make Reservation'
  parentEl: demoEl
  size: 'small'
.render()

new Button
  label: 'Make Reservation'
  parentEl: demoEl
  size: 'normal'
.render()

new Button
  label: 'Make Reservation'
  parentEl: demoEl
  size: 'large'
.render()

new Button
  label: 'Make Reservation'
  parentEl: demoEl
  size: 'huge'
.render()

button = new Button
  label: 'Make Reservation'
  parentEl: demoEl
  size: 'massive'
.render()

show = document.querySelector '#show'
hide = document.querySelector '#hide'

show.onclick = ->
  button.show()

hide.onclick = ->
  button.hide()

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
