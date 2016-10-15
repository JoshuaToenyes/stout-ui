button   = require '../../button'
dropdown = require '../../dropdown'
parser   = require 'stout-client/parser'


window.onload = ->
  parser.parse().then ->
    $stout.get('#btn-basic').click = ->
      $stout.get('#dropdown-basic').toggle()
