Mask = require '../../../mask/Mask'



describe 'stout-ui/mask/Mask', ->

  for property in ['definition', 'matchers', 'optional', 'transforms']
    it "has a `##{property}` property", ((property) ->
      -> expect((new Mask)[property]).not.to.be.undefined
    )(property)

  for method in ['mask', 'raw']
    it "has a `##{method}()` method", ((method) ->
      -> expect(new Mask).to.respondTo method
    )(method)

  describe '#mask()', ->
    it 'the `S`, `x`, and `X` mask characters match alphabetic characters', ->
      for c in ['S', 'X', 'x']
        m = new Mask c
        expect(m.mask '').to.equal ''
        expect(m.mask('a').toLowerCase()).to.equal 'a'
        expect(m.mask('A').toLowerCase()).to.equal 'a'
        expect(m.mask '1').to.equal ''

    it 'the `#` mask character matches numeric characters', ->
      m = new Mask '#'
      expect(m.mask '').to.equal ''
      expect(m.mask 'a').to.equal ''
      expect(m.mask 'Z').to.equal ''
      expect(m.mask '0').to.equal '0'
      expect(m.mask '9').to.equal '9'

    it 'the `*` mask character matches any word characters', ->
      m = new Mask '*'
      expect(m.mask '').to.equal ''
      expect(m.mask 'a').to.equal 'a'
      expect(m.mask 'Z').to.equal 'Z'
      expect(m.mask '0').to.equal '0'
      expect(m.mask '9').to.equal '9'

    it 'masks simple numeric values', ->
      m = new Mask '###'
      expect(m.mask '12a').to.equal '12'
      expect(m.mask '1xy12').to.equal '112'
      expect(m.mask 'a12a').to.equal '12'

    it 'masks simple any-case alphabetic values', ->
      m = new Mask 'SSSS'
      expect(m.mask 'abcd').to.equal 'abcd'
      expect(m.mask '1bcd').to.equal 'bcd'
      expect(m.mask 'ABcD').to.equal 'ABcD'
      expect(m.mask 'xYzC').to.equal 'xYzC'
      expect(m.mask 'xY12').to.equal 'xY'

    it 'masks simple mixed alphabetic and numeric values', ->
      m = new Mask '#SS#'
      expect(m.mask '1aa2').to.equal '1aa2'
      expect(m.mask '9XX2').to.equal '9XX2'
      expect(m.mask '9X11').to.equal '9X'

    it 'masks with literal mask characters', ->
      m = new Mask '(##SS)'
      expect(m.mask '11AA').to.equal '(11AA)'
      expect(m.mask '11').to.equal '(11'
      expect(m.mask '2xAA').to.equal '(2'

    it 'masks with literal whitespace mask characters', ->
      m = new Mask '#### #### ####'
      expect(m.mask '11112222333').to.equal '1111 2222 333'
      expect(m.mask '11').to.equal '11'
      expect(m.mask '11112').to.equal '1111 2'

    it 'behaves as expected with multiple mask literals', ->
      m = new Mask '((#))'
      expect(m.mask '').to.equal ''
      expect(m.mask '1').to.equal '((1))'
      expect(m.mask 'XXXX').to.equal '(('
      expect(m.mask 'XXX12').to.equal '((1))'

    it 'masks standard US phone numbers', ->
      m = new Mask '(###) ###-####'
      expect(m.mask '').to.equal ''
      expect(m.mask '123').to.equal '(123) '
      expect(m.mask '12345').to.equal '(123) 45'
      expect(m.mask '12345678').to.equal '(123) 456-78'
      expect(m.mask '1234567890').to.equal '(123) 456-7890'
      expect(m.mask '1234567890123').to.equal '(123) 456-7890'

    it 'masks international style US phone numbers', ->
      m = new Mask '+1 (###) ###-####'
      expect(m.mask '').to.equal ''
      expect(m.mask '+1123').to.equal '+1 (123) '
      expect(m.mask '+112345').to.equal '+1 (123) 45'
      expect(m.mask '+112345678').to.equal '+1 (123) 456-78'
      expect(m.mask '+11234567890').to.equal '+1 (123) 456-7890'
      expect(m.mask '+11234567890123').to.equal '+1 (123) 456-7890'

    it 'masks with optional characters', ->
      m = new Mask '#?SS?#'
      expect(m.mask '1aa').to.equal '1aa'
      expect(m.mask 'aa1').to.equal 'aa1'
      expect(m.mask 'a1').to.equal 'a1'
      expect(m.mask '1bb5xx').to.equal '1bb5'
      expect(m.mask '1b55').to.equal '1b5'

    it 'mask-matching user-typed literals are output', ->
      m = new Mask '()()(#)'
      expect(m.mask '()()(a').to.equal '()()('

    it 'masks with optional characters and literals', ->
      m = new Mask '(##?#?) ###'
      expect(m.mask '123456').to.equal '(123) 456'
      expect(m.mask '(').to.equal '('
      expect(m.mask '(1) 23456').to.equal '(1) 234'
      expect(m.mask '(14)23456').to.equal '(14) 234'

    it 'transforms `X` defined mask characters to uppercase', ->
      m = new Mask 'XX ####'
      expect(m.mask 'aa1111').to.equal 'AA 1111'
      expect(m.mask 'bb').to.equal 'BB '

    it 'transforms `x` defined mask characters to lowercase', ->
      m = new Mask 'xx ####'
      expect(m.mask 'aA').to.equal 'aa '
      expect(m.mask 'BB12').to.equal 'bb 12'

    it 'optional literals are not included until after input passes it', ->
      m = new Mask '###-?#?#?#?'
      expect(m.mask '123').to.equal '123'
      expect(m.mask '1231').to.equal '123-1'


  describe.only '#getUpdatedCursorPosition()', ->

    it 'advances position if entered value is conformant to mask literals', ->
      m = new Mask '++#'
      v = '++'
      mv = m.mask v
      expect(m.getUpdatedCursorPosition(2, v, mv)).to.equal 2

    it 'doesn\'t change the position if the masked value doesn\'t update', ->
      m = new Mask '++++'
      v = '+Q+'
      mv = m.mask v
      expect(m.getUpdatedCursorPosition(1, v, mv)).to.equal 1

    it 'advances cursor past mask-inserted literals', ->
      m = new Mask '++S++'
      v = '++A'
      mv = m.mask v
      expect(m.getUpdatedCursorPosition(3, v, mv)).to.equal 5

    it 'positions cursor right after entered character', ->
      m = new Mask '(###) ###'
      v = '(1239)  9'
      mv = '(123)  99'
      expect(m.getUpdatedCursorPosition(5, v, mv)).to.equal 8


  describe '#raw()', ->

    it 'removes simple literals', ->
      m = new Mask '+SS+'
      expect(m.raw '+AA+').to.equal 'AA'
      expect(m.raw '+XY+').to.equal 'XY'

    it 'removes masks with optional characters', ->
      m = new Mask '##? ###'
      expect(m.raw '12 123').to.equal '12123'
      expect(m.raw '1 123').to.equal '1123'

    it 'removes masks with multiple optional characters', ->
      m = new Mask '(##?#?) ###'
      expect(m.raw '(1) 123').to.equal '1123'
      expect(m.raw '(12) 123').to.equal '12123'
      expect(m.raw '(123) 123').to.equal '123123'

    it 'returns the raw value of US phone numbers like "+1 (###) ###-####"', ->
      m = new Mask '+1 (###) ###-####'
      expect(m.raw '+1 (406) 555').to.equal '406555'
      expect(m.raw '+1 (406').to.equal '406'
      expect(m.raw '+1 (406) 555-1212').to.equal '4065551212'
      expect(m.raw '+1 (619) 555-1212').to.equal '6195551212'

    it 'returns the raw value of US phone numbers like "(###) ###-####"', ->
      m = new Mask '(###) ###-####'
      expect(m.raw '(406) 555').to.equal '406555'
      expect(m.raw '(406').to.equal '406'
      expect(m.raw '(406) 555-1212').to.equal '4065551212'

    it 'returns the raw value of US phone numbers like "###.###.####"', ->
      m = new Mask '###.###.####'
      expect(m.raw '406.555').to.equal '406555'
      expect(m.raw '406').to.equal '406'
      expect(m.raw '406.555.1212').to.equal '4065551212'

    it 'returns the raw value of US zip codes', ->
      m = new Mask '#####-?#?#?#?#?#?'
      expect(m.raw '59106').to.equal '59106'
      expect(m.raw '59106-12332').to.equal '5910612332'

    it 'returns the raw values of Visa/MC credit cards', ->
      m = new Mask '#### #### #### ####'
      expect(m.raw '1111 2222 3333 4444').to.equal '1111222233334444'
      expect(m.raw '1111 2222 ').to.equal '11112222'

    it 'returns the raw values of AMEX credit cards', ->
      m = new Mask '#### ###### #####'
      expect(m.raw '1111 222222 33333').to.equal '111122222233333'
      expect(m.raw '1111 222222 33').to.equal '111122222233'
