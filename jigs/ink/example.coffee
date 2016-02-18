ink = require 'stout/ui/traits/ink'

require './example.sass'

demoEl = document.querySelector '#demo'
expand = document.querySelector '#expand'
fade = document.querySelector '#fade'

ink.initInkMouseEvents demoEl

demoInk = null

expand.onclick = ->
  if demoInk isnt null then return
  r = demoEl.getBoundingClientRect()
  demoInk = ink.expandInk demoEl, 0, 0, r.width, r.height

fade.onclick = ->
  if demoInk is null then return
  ink.fadeInk demoInk, 0
  demoInk = null
