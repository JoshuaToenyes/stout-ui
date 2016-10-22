Draggable        = require '../../traits/Draggable'
Interactive      = require '../../interactive/Interactive'
InteractiveView  = require '../../interactive/InteractiveView'
ResizableView    = require '../../resizable/ResizableView'
parser           = require 'stout-client/parser'

ResizableFixture = InteractiveView.extend 'ResizableFixture',
  traits: [ResizableView, Draggable]


window.onload = ->
  parser.parse().then ->

    basic = new ResizableFixture
      context: new Interactive
      root: document.getElementById('basic-resizable')

    basic.render().catch console.error

    basic.on 'resize resizestart resizeend', (e) ->
      console.log e.name, e.data

    minmax = new ResizableFixture
      context: new Interactive
      root: document.getElementById('min-max-resizable')
      minWidth: 50
      minHeight: 50
      maxWidth: 500
      maxHeight: 500

    minmax.render().catch console.error
