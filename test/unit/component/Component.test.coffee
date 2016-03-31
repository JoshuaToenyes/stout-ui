Component = require '../../../component/Component'
Promise   = require 'stout-core/promise/Promise'



describe 'stout-ui/component/Component', ->

  s1 = c = null

  beforeEach ->
    c = new Component
    s1 = sinon.spy()


  it 'registers the "show", "hide", and "transition" events', ->
    expect(c.eventRegistered 'show').to.be.true
    expect(c.eventRegistered 'hide').to.be.true
    expect(c.eventRegistered 'transition').to.be.true

  for property in ['visibility']
    it "has a `##{property}` property", ((property) ->
      -> expect(c[property]).not.to.be.undefined
    )(property)

  it 'the #visibility property defaults to "unrendered"', ->
    expect(c.visibility).to.equal 'unrendered'

  for method in ['show', 'hide', 'transitionIn', 'transitionOut']
    it "has a `##{method}()` method", ((method) ->
      -> expect(c).to.respondTo method
    )(method)

  for method, event of {
    show: 'show',
    hide: 'hide',
    transitionIn: 'transition:in',
    transitionOut: 'transition:out'
    }

    describe "##{method}()", ->

      it "returns a promise", ((method) ->
        -> expect(c[method]()).to.be.an.instanceof Promise
      )(method)

      it "fires a \"#{event}\" event", ((method, event) ->
        (done) ->
          c.on event, -> done()
          c[method]()
      )(method, event)
