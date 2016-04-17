###*
#
#
#
#
###
IllegalArgumentErr  = require('stout-core/err').IllegalArgumentErr
HasValidationStates = require 'stout-core/traits/HasValidationStates'
keys                = require 'lodash/keys'
Map                 = require 'stout-core/collection/Map'
merge               = require 'lodash/merge'


BUILT_IN_VALIDATORS =
  'max':      require 'stout-core/validator/Max'
  'min':      require 'stout-core/validator/Min'
  'size':     require 'stout-core/validator/Size'
  'required': require 'stout-core/validator/Required'


validators = new Map()

for k, v of BUILT_IN_VALIDATORS
  validators.put k, v

# Generate the messages regular expression.
states = keys(HasValidationStates.STATES).join '|'
msgsRegExp = new RegExp "(#{states})\\[([^\\]]+)\\]", 'g'

###*
# Parses-out messages from validator descriptor.
#
# @param {string} - Validator descriptor.
#
# @returns {Object} Messages object keyed by validator state.
#
# @function parseMessages
# @inner
###
parseMessages = (v) ->
  msgs = {}
  while (res = msgsRegExp.exec v) isnt null
    if res.length >= 3 then msgs[res[1]] = res[2]
  msgs


###*
# Parses and instantiates the validator.
#
# @param {string} - Validator descriptor.
#
# @
#
###
parseValidator = (v) ->
  v = v.split ':'
  cls = validators.get v[0]

  if not cls then throw new IllegalArgumentErr "Validator \"#{v[0]}\" does not
  exist or is not registered."

  # If arguments were specified.
  if v[1]
    # Remove extra whitespace and convert to array.
    args = v[1].split(',').map (s) -> s.trim()
  else
    args = []

  new (Function.prototype.bind.apply cls, [null].concat args)


###*
# Parses a validator string and instantiates the appropriate Validator classes.
#
# @exports stout-ui/validator/parser
# @function parser
###
module.exports.parse = (s) ->

  # Split validators on delimiter character.
  vs = s.split '|'
  vals = []

  # Parse each validator descriptor.
  for v in vs
    v = v.trim()
    if v.length is 0 then continue
    val = parseValidator v
    merge val.messages, parseMessages v
    vals.push val

  vals


###*
# The validators map which can be added-to for extending the parser's vocabulary
# of validators.
#
# @exports stout-ui/validator/parser.validators
###
module.exports.validators = validators
