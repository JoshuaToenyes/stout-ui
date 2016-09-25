drawer = require '../../drawer'
tree   = require '../../tree'
button = require '../../button'
parser = require 'stout-client/parser'


window.onload = ->
  parser.parse().then ->
    $stout.get('#drawer-toggle').click = ->
      $stout.get('#drawer').toggle()
