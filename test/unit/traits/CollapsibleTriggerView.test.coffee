CollapsibleTriggerView = require '../../../traits/CollapsibleTriggerView'
Interactive            = require '../../../interactive/Interactive'
InteractiveView        = require '../../../interactive/InteractiveView'


class Fixture extends InteractiveView
  @useTrait CollapsibleTriggerView
  constructor: -> super arguments...



describe.only 'stout-ui/traits/CollapsibleTriggerView', ->

  c = null

  beforeEach ->
    c = new Fixture context: new Interactive, template: ''

  for prop in 'collapsible collapsed expanded expanding collapsing'.split /\s+/
    it "has a `##{prop}` property", ((prop) ->
      -> expect(c[prop]).to.not.be.undefined
    )(prop)

  for method in 'collapse expand toggle'.split /\s+/
    it "has a `##{method}()` method", ((method) ->
      -> expect(c).to.respondTo method
    )(method)
