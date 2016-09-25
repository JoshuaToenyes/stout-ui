toc    = require '../../toc'
parser = require 'stout-client/parser'


window.onload = ->

  parser.parse().done ->
    console.log 'done!'
