radioButton = require '../../radio-button'
radioGroup  = require '../../radio-group'
RadioButton = require '../../radio-button/RadioButton'
RadioButtonView = require '../../radio-button/RadioButtonView'

window.onload = ->

  makeRadioButtons = (size, type) ->
    for l in ['Select X', 'Select Y', 'Select Z']
      new RadioButtonView {label: l, context: new RadioButton, size, type}

  radioButton.factory
    label: 'Select this test item.'
    parentEl: '.simple'
  .render()

  radioGroup.factory
    parentEl: '.group'
    contents: makeRadioButtons()
  .render()


  for size in ['tiny', 'small', 'normal', 'large', 'huge', 'massive']
    radioGroup.factory
      parentEl: ".size-#{size}"
      contents: makeRadioButtons(size)
    .render()


  for type in ['default', 'inverse', 'primary', 'danger', 'warn']
    radioGroup.factory
      parentEl: ".type-#{type}"
      contents: makeRadioButtons(undefined, type)
    .render()
