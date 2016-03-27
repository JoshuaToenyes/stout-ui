checkboxFactory = require '../../checkbox'

window.onload = ->

  checkboxFactory
    label: 'Select this test item.'
    parent: '.simple'
  .render()

  checkboxFactory
    label: 'Select this other test item.'
    parent: '.simple'
  .render()

  checkboxFactory
    label: 'Lastly, another one.'
    parent: '.simple'
  .render()

  for size in ['tiny', 'small', 'normal', 'large', 'huge', 'massive']
    checkboxFactory
      label: "This is a <code>#{size}</code> checkbox."
      parent: ".size-#{size}"
      size: size
    .render()


  for style in ['default', 'inverse', 'primary', 'danger', 'warn']
    checkboxFactory
      label: "This is a <code>#{style}</code> checkbox."
      parent: ".style-#{style}"
      type: style
      selected: true
    .render()
