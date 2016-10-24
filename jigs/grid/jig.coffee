button = require '../../button'
grid   = require '../../grid'
parser = require 'stout-client/parser'


window.onload = ->
  parser.parse().then ->

    grid = $stout.get('#basic-grid')

    $stout.get('#btn-add').click = ->
      randomSize = -> Math.max 5, Math.ceil(Math.random() * 8)
      i = 2
      while i--
        height = randomSize()
        width = randomSize()
        grid.context.createItem {height, width}
