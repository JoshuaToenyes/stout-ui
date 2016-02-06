Ink = require 'stout/ui/ink/Ink'

require './example.sass'

demoEl = document.querySelector '#demo'
expand = document.querySelector '#expand'
fade = document.querySelector '#fade'

Ink.initInkMouseEvents demoEl

demoInk = null

expand.onclick = ->
  if demoInk isnt null then return
  r = demoEl.getBoundingClientRect()
  demoInk = Ink.expandInk demoEl, 0, 0, r.width, r.height

fade.onclick = ->
  if demoInk is null then return
  Ink.fadeInk demoInk, 0
  demoInk = null
