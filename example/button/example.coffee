Button = require 'stout/ui/button/Button'

require './example.sass'
require 'button/button.sass'

# atomIcon = require './atom-icon.svg'
demoEl = document.getElementById('demo')

button = new Button
  label: 'Make Reservation'
  parentEl: demoEl

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

button.render()
# btop.render()
# bbottom.render()
# bleft.render()
# bright.render()
# bnolabel.render()
