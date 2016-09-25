parser = require 'stout-client/parser'

window.onload = ->
  parser.parse().catch console.error
