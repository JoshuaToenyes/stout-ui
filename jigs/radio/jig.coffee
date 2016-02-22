RadioButton = require '../../radio/RadioButton'

window.onload = ->

  new RadioButton
    label: 'Select this test item.'
    parentEl: '.simple'
  .render()
