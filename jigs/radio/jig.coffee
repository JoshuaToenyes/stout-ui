RadioButton = require '../../radio/RadioButton'

window.onload = ->

  window.rb = new RadioButton
    label: 'Select this test item.'
    parentEl: '.simple'

  window.rb.render()
