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
      if not @matchers.hasOwnProperty(m) and m isnt @optional
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
  raw: (input) ->

    definition = @definition
    d = i = 0
    raw = ''

    loop

      # End if we're out of user input or mask characters.
      if i >= input.length or d >= definition.length then break

      # Grab the input and mask definition characters.
      c = input[i]
      m = definition[d]

      # If this mask character is the optional indicator, move on to the next.
      if m is @optional
        d++
        continue

      matched = false

      # If this is not a literal character, attempt to match it.
      if @matchers.hasOwnProperty(m)
        matched = @matchers[m].test(c)

        # If it was matched, then output the matched character.
        if matched
          raw += c

        # If it wasn't matched, then it must be optional. Re-check this input
        # character against the next mask character.
        else
          i--

      i++
      d++

    # Return the accumulated raw value.
    raw
