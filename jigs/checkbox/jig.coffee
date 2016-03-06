Checkbox = require '../../checkbox/Checkbox'

window.onload = ->

  window.check = new Checkbox
    label: 'Select this test item.'
    parent: '.simple'
  check.render()

  new Checkbox
    label: 'Select this other test item.'
    parent: '.simple'
  .render()

  new Checkbox
    label: 'Lastly, another one.'
    parent: '.simple'
  .render()

  for size in ['tiny', 'small', 'normal', 'large', 'huge', 'massive']
    new Checkbox
      label: "This is a <code>#{size}</code> checkbox."
      parent: ".size-#{size}"
      size: size
    .render()
