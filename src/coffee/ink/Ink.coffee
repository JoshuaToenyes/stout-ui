
require 'ink/ink.sass'


module.exports = class Ink

  constructor: (el) ->
    el.addEventListener 'mousedown', (e) ->
      e.stopPropagation()
      ink = document.createElement 'div'
      r = el.getBoundingClientRect()
      left = e.clientX - r.left
      top = e.clientY - r.top
      ink.style.transform = "translateX(#{left}px) translateY(#{top}px)"
      ink.classList.add 'sui-ink'
      el.appendChild ink
      setTimeout ->
        el.removeChild ink
      , 3100
    , true
