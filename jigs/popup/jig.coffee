Button          = require '../../button'
Draggable       = require '../../traits/Draggable'
Interactive     = require '../../interactive/Interactive'
InteractiveView = require '../../interactive/InteractiveView'
parser          = require 'stout-client/parser'
PopupView       = require '../../popup/PopupView'

class DraggableFixture extends InteractiveView
  @useTrait Draggable
  constructor: ->
    super arguments...


window.onload = ->
  parser.parse().then ->
    popups = []
    visible = false

    button = $stout.getFirst('ui-button')
    button.click = ->
      if visible
        p.hide() for p in popups
        visible = false
      else
        p.show() for p in popups
        visible = true

    createPopup = (pos) ->
      p = new PopupView {
        template: '',
        context: new Interactive
        affixTo: button
        parentEl: document.body
        affixPosition: pos
        contents: pos
      }
      p.render()
      popups.push p

    createPopup(pos) for pos in [
      'left top'
      'center top'
      'right top'
      'left center'
      'right center'
      'bottom left'
      'bottom center'
      'bottom right'
    ]

    draggable = new DraggableFixture {
      template: '',
      context: new Interactive
      parentEl: '.ex.draggable'
      class: 'draggable-example'
    }
    draggable.render()

    topPopup = new PopupView {
      template: '',
      context: new Interactive
      affixTo: draggable
      parentEl: document.body
      affixPosition: 'top center'
      contents: 'moveable popup'
    }
    topPopup.render().then -> topPopup.show()

    draggable = new DraggableFixture {
      template: '',
      context: new Interactive
      parentEl: '.ex.draggable'
      class: 'draggable-example'
    }
    draggable.render()

    bottomPopup = new PopupView {
      template: '',
      context: new Interactive
      affixTo: draggable
      parentEl: document.body
      affixPosition: 'right center'
      contents: 'moveable popup'
    }
    bottomPopup.render().then -> bottomPopup.show()

  .catch console.error
