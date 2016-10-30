button = require '../../button'
grid   = require '../../grid'
parser = require 'stout-client/parser'


window.onload = ->
  parser.parse().then ->

    grid = $stout.get('#basic-grid')

    $stout.get('#btn-add').click = ->
      randomSize = -> Math.max 1, Math.ceil(Math.random() * 3)
      i = 2
      while i--
        height = randomSize()
        width = randomSize()
        item = grid.context.createItem {height, width}
        image = Math.ceil(Math.round(Math.random() * 1000))
        item.root.style.backgroundImage = "url('https://unsplash.it/800?image=#{image}')"
        #item.click = -> @remove()


    $stout.get('#btn-clear').click = ->
      grid.context.destroyGridItems()
