card   = require '../../card'
parser = require 'stout-client/parser'


window.onload = ->

  parser.parse()

  $stout.get('#flip-example').click = ->
    @flip().catch (e) -> console.error e
