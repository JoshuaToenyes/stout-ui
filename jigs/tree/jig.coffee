tree   = require '../../tree'
parser = require 'stout-client/parser'


window.onload = ->
  parser.parse().error (e) -> console.error e
