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
  reduce parts, (a, v) ->
    if v isnt undefined then a[v]
  , variables

module.exports =

  ###*
  # Loads default UI variables.
  #
  # @param {Object} vars - The default values to load.
  #
  # @function default
  ###
  default: (path, vars) ->
    if variables[path]
      throw new err.Err "UI variable defaults \"#{path}\" already defined."
    variables[path] = vars

  get: read
