RadioButton = require '../../radio/RadioButton'
RadioGroup = require '../../radio/RadioGroup'

window.onload = ->

  window.rb = new RadioButton
    label: 'Select this test item.'
    parent: '.simple'

  window.rb.render()



  window.group = group = new RadioGroup()

  group.on 'selection:change', (e) ->
    console.log 'selection change!', e

  btna = new RadioButton
    label: 'Selection A'
    parent: '.group'
    group: group

  btna.render()
  btna.on 'select', -> console.log 'You have selected A!'
  btna.on 'unselect', -> console.log 'You have unselected A...'

  new RadioButton
    label: 'Selection B'
    parent: '.group'
    group: group
  .render()

  new RadioButton
    label: 'Selection C'
    parent: '.group'
    group: group
  .render()
