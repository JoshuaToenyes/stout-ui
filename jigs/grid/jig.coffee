button = require '../../button'
grid   = require '../../grid'
parser = require 'stout-client/parser'


window.onload = ->
  parser.parse().then ->

    grid = $stout.get('#basic-grid')
    savedItems = {}

    $stout.get('#btn-save').click = ->
      savedItems = {}
      grid.context.items.forEach (item) ->
        savedItems[item.id] =
          row: item.row
          column: item.column
          height: item.height
          width: item.width
          contents: item.root.style.backgroundImage

    $stout.get('#btn-reload').click = ->
      grid.context.destroyGridItems()
      for id, item of savedItems
        v = grid.context.createItem {height: item.height, width: item.width, row: item.row, column: item.column}
        v.root.style.backgroundImage = item.contents


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
