RadioButton = require '../../radio/RadioButton'
RadioGroup = require '../../radio/RadioGroup'

window.onload = ->

  new RadioButton
    label: 'Select this test item.'
    parent: '.simple'
  .render()

  g = new RadioGroup parent: '.group'
  g.addButton label: 'Selection X'
  g.addButton label: 'Selection Y'
  g.addButton label: 'Selection Z'
  g.render()


  for size in ['tiny', 'small', 'normal', 'large', 'huge', 'massive']
    g = new RadioGroup parent: ".size-#{size}"
    g.addButton
      label: "Selection A of size #{size}."
      size: size
    g.addButton
      label: "Selection B of size #{size}."
      size: size
    g.addButton
      label: "Selection C of size #{size}."
      size: size
    g.render()

  for style in ['default', 'inverse', 'primary', 'danger', 'warn']
    g = new RadioGroup parent: ".style-#{style}"
    g.addButton
      label: "Selection A of style #{style}."
      style: style
    g.addButton
      label: "Selection B of style #{style}."
      style: style
    g.addButton
      label: "Selection C of style #{style}."
      style: style
    g.render()
