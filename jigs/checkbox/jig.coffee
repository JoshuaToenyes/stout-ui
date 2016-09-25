checkboxFactory = require '../../checkbox'
parser = require 'stout-client/parser'

window.onload = ->

  parser.parse()

  checkboxFactory
    label: 'Select this test item.'
    parentEl: '.simple'
  .render()

  checkboxFactory
    label: 'Select this other test item.'
    parentEl: '.simple'
  .render()

  checkboxFactory
    label: 'Lastly, another one.'
    parentEl: '.simple'
  .render()

  for size in ['tiny', 'small', 'normal', 'large', 'huge', 'massive']
    checkboxFactory
      label: "This is a <code>#{size}</code> checkbox."
      parentEl: ".size-#{size}"
      size: size
    .render()


  for style in ['default', 'inverse', 'primary', 'danger', 'warn']
    checkboxFactory
      label: "This is a <code>#{style}</code> checkbox."
      parentEl: ".style-#{style}"
      type: style
      selected: true
    .render()
