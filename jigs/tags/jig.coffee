Button = require '../../button/Button'
parser = require 'stout-client/parser'
scope = require 'stout-client/scope'


document.addEventListener 'DOMContentLoaded', ->

  parser.parse(document.body)

  scope.handleClick = ->
    console.log 'got a click!'
