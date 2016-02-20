###*
# @overview This module loads default variables in to the Stout UI variable
# system which can shared compiled variables between SASS and JavaScript with
# support for extension.
# @module vars/default
###

err    = require 'stout-core/err'
reduce = require 'lodash/reduce'

variables = {}

###*
# Parses the passed variable path and attempts to read the value from the
# internal store.
#
# @function read
###
read = (varPath) ->
  parts = varPath.split '/'
  v = reduce parts, (a, v) ->
    if a isnt undefined then a[v]
  , variables
  if v is undefined
    throw new err.Err "UI variable \"#{varPath}\" is undefined."
  else
    v

module.exports =

  ###*
  # Loads default UI variables.
  #
  # @param {Object} vars - The default values to load.
  #
  # @function default
  ###
  default: (filename, vars) ->
    matches = /([\w\-_\.]+)\.js/.exec(filename)
    path = matches[1]
    if variables[path]
      throw new err.Err "UI variable defaults \"#{path}\" already defined."
    variables[path] = vars

  read: read


  readTime: (varPath) ->
    v = read varPath
    t = parseInt v
    if /\d+ms$/.test v
      t
    else if /\d+s$/.test v
      t * 1000
    else
      throw new err.Err "UI variable \"#{varPath}\" is not in time units."
