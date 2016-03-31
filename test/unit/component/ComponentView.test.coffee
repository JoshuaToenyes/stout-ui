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

  for method in ['getRenderedDimensions', 'show', 'hide', 'transitionIn',
    'transitionOut']
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
            # If transitioning-in or showing, we must first hide the view
            # to avoid an error.
            if event is 'transition:in' or event is 'show'
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
          e = new Error('Expected TransitionCanceled but got no exception.')
          cv.render().then ->
            cv.transitionIn(99999)
            .then -> done(e)
            .catch -> done()
            cv[method]()
          .catch done
      )(method)

      it "cancels transition-out when #{method}ing", ((method) ->
        (done) ->
          e = new Error('Expected TransitionCanceled but got no exception.')
          cv.render().then ->
            cv.transitionOut(99999)
            .then -> done(e)
            .catch -> done()
            cv[method]()
      )(method)

  describe '#getRenderedDimensions()', ->

    beforeEach ->
      cv.root.style.width = '100px'
      cv.root.style.height = '200px'

    it "returns a promise", ->
      expect(cv.getRenderedDimensions()).to.be.an.instanceof Promise

    it 'resolves to an object with `width` and `height` members', (done) ->
      cv.getRenderedDimensions()
      .then (v) ->
        expect(v.width).not.to.be.undefined
        expect(v.height).not.to.be.undefined
        done()
      .catch done

    it 'resolves to the size of the element if visible', (done) ->
      cv.parent = document.body
      cv.render()
      .then ->
        expect(cv.visible).to.be.true
        cv.getRenderedDimensions().then (v) ->
          expect(v.width).to.be.within 99, 101
          expect(v.height).to.be.within 199, 201
          done()
      .catch done

    it 'resolves to the size of the element if rendered and hidden', (done) ->
      cv.parent = document.body
      cv.options.showOnRender = false
      cv.render()
      .then ->
        expect(cv.hidden).to.be.true
        cv.getRenderedDimensions().then (v) ->
          expect(v.width).to.be.within 99, 101
          expect(v.height).to.be.within 199, 201
          done()
      .catch done

    it 'resolves to the size of the element if not rendered', (done) ->
      cv.getRenderedDimensions().then (v) ->
        expect(v.width).to.be.within 99, 101
        expect(v.height).to.be.within 199, 201
        done()
      .catch done
