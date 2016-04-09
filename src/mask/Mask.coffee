###*
#
#
#
#
###
Foundation = require 'stout-core/base/Foundation'
isString   = require 'lodash/isString'



###*
#
# ## Empty Input
# If the input to be masked is empty, by definition the output of the `#mask()`
# method is also empty. In other words, if the first character of the mask
# definition is a literal, and the input string is empty, it is not output.
#
# ## Built-in Matchers
# [S] Any alphabetic chracter.
# [#] Any number
# [*] Any alphanumeric character.
#
# ## Built-in Transforms
# [x] An alphabetic character, converted to lowercase.
# [X] An alphabetic character, converted to uppercase.
#
# ## Optional Characters
# Optional user-input characters can be specified by following them with the
# character specified by the `#optional` property. For example, a numeric
# input that could be one, two, or three numbers long could be specified by the
# mask `##?#?`. The two `?` characters (the default "optional" specifier)
# indicate that the second and third `#` input are optional.
#
# ## Optional Literals
# Literals are normally output with the mask immediately following input which
# is long enough to reach the literal. However, if the literal is followed by
# the `#optional` character (`?` by default) it is not output until the input
# string length is at least long enough to pass the optional literal.
#
# @param {Object|string} init - Initiation object, or the mask definition if
# a string.
#
# @param {Array.<string>} events - Events to immediately register prior to
# instantiation.
#
# @exports stout-ui/mask/Mask
# @extends stout-core/base/Foundation
# @constructor
###
module.exports = class Mask extends Foundation

  constructor: (init, events) ->
    if isString init then init = definition: init
    super init, events


  ###*
  # The mask definition string.
  #
  # @member {string} definition
  # @memberof stout-ui/mask/Mask#
  ###
  @property 'definition',
    default: ''
    type: 'string'


  ###*
  # Matchers are used to map mask characters to allowed user input characters.
  #
  # @member {Object.<string, RegExp>} matchers
  # @memberof stout-ui/mask/Mask#
  ###
  @property 'matchers',
    default:
      'S': /[a-zA-Z]/
      'x': /[a-zA-Z]/
      'X': /[a-zA-Z]/
      '#': /\d/
      '*': /\w/


  ###*
  # Readyonly property indicating the maximum length of this mask.
  #
  # @member {number} maxlength
  # @memberof stout-ui/mask/Mask#
  # @readonly
  ###
  @property 'maxlength',
    readonly: true
    get: ->
      n = 0
      for c in @definition
        n++ unless c is @optional
      n


  ###*
  # Optional mask definition character.
  #
  # @member {string} optional
  # @memberof stout-ui/mask/Mask#
  ###
  @property 'optional',
    default: '?'


  ###*
  # Transforms are used to transform user input characters.
  #
  # @member transforms
  # @memberof stout-ui/mask/Mask#
  ###
  @property 'transforms',
    default:
      'x': (c) -> c.toLowerCase()
      'X': (c) -> c.toUpperCase()


  ###*
  # Returns `true` if the passed character is a defined mask definition
  # character.
  #
  # @method _isMaskCharacter
  # @memberof stout-ui/mask/Mask#
  # @private
  ###
  _isMaskCharacter: (m) ->
    @matchers.hasOwnProperty(m)


  ###*
  # Returns the proper position of the cursor after an insert. It returns the
  # integer number indicating where the cursor should be positioned after an
  # insert occurs. This method does not actually position the character, instead
  # that is left to the calling-class.
  #
  # @param {number} cursorPos - The position of the cursor when the insert
  # occurs.
  #
  # @param {string} value - The string value of the user input prior to masking.
  #
  # @returns {number|null} Returns the position to place the cursor. If the returned
  # value is `null`, then no position update should occur.
  #
  # @method positionCursor
  # @memberof stout-ui/mask/Mask#
  ###
  getUpdatedCursorPosition: (cursorPos, value, maskedValue) ->

    # Move cursor position back by one.
    cursorPos--

    # If the entered value is part of the mask or is a value conformant to the
    # mask in the correct positioning (i.e. the mask didn't move the recently
    # entered character) then move the cursor forward naturally.
    if maskedValue[cursorPos] is enteredValue then return cursorPos + 1

    # If the length doesn't change after masking, and the user didn't enter a
    # mask literal (which would have been detected previously) it must have
    # been an invalid value or the mask has reached full length. Don't update
    # the cursor position.
    if value.length - 1 is maskedValue.length then return cursorPos

    # If typing at the end of the value, advanced past mask-inserted literal
    # characters.
    if cursorPos + 1 is value.length then return maskedValue.length

    # Get the character entered by the user.
    enteredValue = value[cursorPos]

    # Iterate through the masked value until the character just-entered is
    # reached.
    while maskedValue[cursorPos] isnt enteredValue and cursorPos < value.length
      cursorPos++

    # Advance the character past the just-typed character.
    cursorPos + 1


  ###*
  # Masks the passed input string, returning the masked value, or the value
  # as it should be presented to the user.
  #
  # @member mask
  # @memberof stout-ui/mask/Mask#
  ###
  mask: (input) ->

    # Convert to string, to be sure.
    input = input.toString()

    # Always return an empty string for zero-length input.
    if input.length is 0 then return ''

    definition = @definition
    d = i = 0
    output = ''

    loop

      # End if we're out of user input or mask characters.
      if d >= definition.length then break

      # Grab the input and mask definition characters.
      c = input[i]
      m = definition[d]

      # Continue to next mask character if this is the optional character.
      if m is @optional
        d++
        continue

      # Check if this mask character is optional.
      optional = definition[d + 1] is @optional

      # If this is a literal character from the mask...
      if not @_isMaskCharacter(m) and m isnt @optional
        d++

        # Only add to output if there is more input...
        if not (optional and i is input.length)
          output += m

        # If typed character matches the literal, advance to next input char.
        if c is m then i++

        continue

      # If we've run out of input chars and mask literals, then break.
      if i >= input.length then break

      # Check if this character matches the mask.
      matches = @matchers[m].test(c)

      # If the character doesn't match the mask character, but is optional,
      # skip past the mask character.
      if not matches and optional
        d += 2
        continue

      # If the user input doesn't match the mask, then continue to the next.
      else if not matches
        i++
        continue

      # If the user input matches, then transform and add to output.
      if @transforms.hasOwnProperty m
        output += @transforms[m](c)

      # Otherwise, just add the user input char to output.
      else
        output += c

      # Increment position counters.
      d++
      i++

    # Return the accumulated output.
    output


  ###*
  # Takes-in a masked string and returns the raw value (the value with the mask
  # removed).
  #
  # @member raw
  # @memberof stout-ui/mask/Mask#
  ###
  raw: (maskedValue) ->

    definition = @definition
    d = i = 0
    raw = ''

    loop

      # End if we're out of the masked value or mask characters.
      if i >= maskedValue.length or d >= definition.length then break

      # Grab the masked value and mask definition characters.
      c = maskedValue[i]
      m = definition[d]

      # If this mask character is the optional indicator, move on to the next.
      if m is @optional
        d++
        continue

      matched = false

      # If this is not a literal character, attempt to match it.
      if @_isMaskCharacter(m)
        matched = @matchers[m].test(c)

        # If it was matched, then output the matched character.
        if matched
          raw += c

        # If it wasn't matched, then it must be optional. Re-check this masked
        # value character against the next mask character.
        else
          i--

      i++
      d++

    # Return the accumulated raw value.
    raw
