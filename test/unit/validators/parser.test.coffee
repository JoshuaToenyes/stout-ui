Map    = require 'stout-core/collection/Map'
Max    = require 'stout-core/validator/Max'
parser = require '../../../validator/parser'


describe 'stout-ui/validators/parser', ->

  s1 = s2 = null

  beforeEach ->
    s1 = sinon.spy()
    s2 = sinon.spy()
    parser.validators.put 's1', s1
    parser.validators.put 's2', s2

  afterEach ->
    parser.validators.remove 's1'
    parser.validators.remove 's2'

  it 'exports the `#parse()` function', ->
    expect(parser.parse).to.be.a 'function'

  it 'has a `#validators` Map member', ->
    expect(parser.validators).to.be.instanceof Map

  it 'can parse a single simple validator', ->
    vals = parser.parse 'max:2'
    expect(vals).to.have.lengthOf 1
    expect(vals[0]).to.be.instanceof Max

  it 'can pass arguments to instantiated validators', ->
    vals = parser.parse 's1:1,5,3'
    expect(s1.calledWith '1', '5', '3').to.be.true

  it 'trims extra whitespace from args', ->
    vals = parser.parse 's1: hello, how  , are you '
    expect(s1.calledWith 'hello', 'how', 'are you').to.be.true

  it 'arguments are not required', ->
    vals = parser.parse 's1'
    expect(s1.args[0]).to.have.lengthOf 0

  it 'can instantiate multiple validators', ->
    vals = parser.parse 's1|s2'
    expect(vals).to.have.lengthOf 2
    expect(s1.calledOnce).to.be.true
    expect(s2.calledOnce).to.be.true

  it 'passes arguments to all instantiated validators', ->
    vals = parser.parse 's1:1,2|s2:3,4'
    expect(s1.calledWith '1', '2').to.be.true
    expect(s2.calledWith '3', '4').to.be.true

  it 'sets a single validation messages', ->
    vals = parser.parse 'max:2:hint[This is the hint]'
    expect(vals[0].messages.hint).to.equal 'This is the hint'

  it 'sets multiple validation messages', ->
    vals = parser.parse 'max:2:hint[hint msg]:warning[warn msg]:error[err msg]'
    m = vals[0].messages
    expect(m.hint).to.equal 'hint msg'
    expect(m.warning).to.equal 'warn msg'
    expect(m.error).to.equal 'err msg'
    expect(m.ok).to.equal ''
