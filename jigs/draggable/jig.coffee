Draggable       = require '../../traits/Draggable'
Interactive     = require '../../interactive/Interactive'
InteractiveView = require '../../interactive/InteractiveView'
parser          = require 'stout-client/parser'

class DraggableFixture extends InteractiveView
  @useTrait Draggable
  constructor: ->
    super arguments...


window.onload = ->
  parser.parse()

  (new DraggableFixture {
    template: '',
    context: new Interactive
    parentEl: '.ex.basic'
    class: 'draggable-example'
  }).render()

  (new DraggableFixture {
    template: '',
    context: new Interactive
    parentEl: '.ex.axis-x'
    axis: "x"
    class: 'draggable-example'
  }).render()

  (new DraggableFixture {
    template: '',
    context: new Interactive
    parentEl: '.ex.axis-y'
    axis: "y"
    class: 'draggable-example'
  }).render()
