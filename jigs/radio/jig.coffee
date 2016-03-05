RadioButton = require '../../radio/RadioButton'

window.onload = ->

  window.rb = new RadioButton
    label: 'Select this test item.'
    parent: '.simple'

  window.rb.render()
