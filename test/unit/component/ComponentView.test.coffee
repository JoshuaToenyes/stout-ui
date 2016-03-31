Component          = require '../../../component/Component'
ComponentView      = require '../../../component/ComponentView'
Promise            = require 'stout-core/promise/Promise'
TransitionCanceled = require('stout-client/exc').TransitionCanceled
ViewNotRenderedErr = require('stout-client/err').ViewNotRenderedErr


describe 'stout-ui/component/ComponentView', ->

  s1 = cv = null

  beforeEach ->
    cv = new ComponentView context: new Component, template: ''
    s1 = sinon.spy()


  it 'registers the "show", "hide", and "transition" events', ->
    expect(cv.eventRegistered 'show').to.be.true
    expect(cv.eventRegistered 'hide').to.be.true
    expect(cv.eventRegistered 'transition').to.be.true

  for property in ['hidden', 'options', 'transitioning', 'transitioningIn',
    'transitioningOut', 'visible']
    it "has a `##{property}` property", ((property) ->
      -> expect(cv[property]).not.to.be.undefined
    )(property)

  for method in ['show', 'hide', 'transitionIn', 'transitionOut']
    it "has a `##{method}()` method", ((method) ->
      -> expect(cv).to.respondTo method
    )(method)

  for method, event of {
    show: 'show',
    hide: 'hide',
    transitionIn: 'transition:in',
    transitionOut: 'transition:out'
    }

    describe "##{method}() returns and events", ->

      it "returns a promise", ((method) ->
        -> expect(cv[method]()).to.be.an.instanceof Promise
      )(method)

      it "fires a \"#{event}\" event", ((method, event) ->
        (done) ->
          cv.render().then ->
            # If transitioning-in we must first hide the view to avoid an error.
            if event is 'transition:in'
              cv.hide().then -> cv[method]()
            else
              cv[method]()
          .error (e) -> done(e)
          .finally -> done()
      )(method, event)

  for method in ['show', 'hide']

    describe "##{method}()", ->

      it "throws a ViewNotRenderedErr if #{method}ing an unrendered view",
      ((method) ->
        (done) ->
          cv[method]()
          .then ->
            done(new Error('Expected ViewNotRenderedErr but got no error.'))
          .error (e) ->
            expect(e).to.be.an.instanceof ViewNotRenderedErr
            done()
      )(method)

      it "cancels transition-in when #{method}ing", ((method) ->
        (done) ->
          if method is 'show' then cv.options.showOnRender = false
          cv.render().then ->
            cv.transitionIn(Infinity)
            .then ->
              done(new Error('Expected TransitionCanceled but got no exception.'))
            .error ->
              done()
            cv[method]()
      )(method)

      it "cancels transition-out when #{method}ing", ((method) ->
        (done) ->
          cv.render().then ->
            cv.transitionOut(Infinity)
            .then ->
              done(new Error('Expected TransitionCanceled but got no exception.'))
            .error ->
              done()
            cv[method]()
      )(method)
