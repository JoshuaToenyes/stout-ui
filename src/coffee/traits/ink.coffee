
require 'ink/ink.sass'

module.exports =

  # The amount of time it should take for the ink to fade out.
  #
  # @property {number} inkFadeTime
  # @public

  inkFadeTime: 800


  # Small time offset to ensure elements are removed/inserted before a CSS
  # animation is completed and a static element state is shown (a flash).
  #
  # @property {number} inkDiffTime
  # @public

  inkDiffTime: 50


  # Calculates the size of the ink in pixels using the passed ink container
  # width and height.
  #
  # @param {number} w - The width of the container element.
  #
  # @param {number} h - The height of the container element.
  #
  # @returns {number} The ink radius.
  #
  # @method calcInkRadius
  # @public

  calcInkRadius: (w, h) ->
    Math.sqrt(Math.pow(w, 2) + Math.pow(h, 2)) / 0.34


  # Returns the amount of time the ink should take to expand within an element
  # with the passed dimension.
  #
  # @param {number} w - The width of the container element.
  #
  # @param {number} h - The height of the container element.
  #
  # @returns {number} The amount of time in milliseconds the ink should take
  # to expand.
  #
  # @method inkExpansionTime
  # @public
  # @todo

  inkExpansionTime: (w, h) ->
    v = 2
    r = @calcInkRadius(w, h)
    Math.max(r / v, 500)



  # Creates a DOM element for the ink.
  #
  # @returns {DOMElement} The ink element.
  #
  # @method createInkElement
  # @public

  createInkElement: ->
    ink = document.createElement 'div'
    inkRun = document.createElement 'div'
    ink.appendChild inkRun
    ink.classList.add 'sui-ink'
    [ink, inkRun]


  # Expands the ink within the passed container element. The ink may be offset
  # within the container element (to position it where a click event occurred,
  # for example). The size of the container element must also be passed so the
  # expanded size of the ink element can be calculated.
  #
  # @param {DOMElement} el - The element to append the ink to (the ink
  # container element).
  #
  # @param {number} x - The x position offset to translate the ink.
  #
  # @param {number} y - The y position offset to translate the ink.
  #
  # @param {number} w - The width of the container element.
  #
  # @param {number} h - The height of the container element.
  #
  # @returns {DOMElement} The ink element.
  #
  # @method expandInk
  # @public

  expandInk: (el, x, y, w, h) ->
    [ink, inkRun] = @createInkElement()
    inkRun.style.animationDuration = @inkExpansionTime(w, h) + 'ms'
    ink.style.transform = "translateX(#{x}px) translateY(#{y}px)"
    s = @calcInkRadius(w, h)
    ink.style.height = "#{s}px"
    ink.style.width = "#{s}px"
    el.appendChild ink
    ink


  # Fades-out the passed ink element
  #
  # @param {DOMElement} ink - The ink element to fade-out.
  #
  # @param {number} t - The number of milliseconds to wait before beginning
  # the fade-out.
  #
  # @method fadeInk
  # @public

  fadeInk: (ink, t) ->
    ink.classList.add 'fade-out'
    setTimeout ->
      ink.parentElement?.removeChild ink
    , @inkFadeTime + Math.max(t, 0)


  # Initializes the passed element as an interactive ink element. Ink will
  # expand within the passed element on mousedown, then fade on mouseup.
  #
  # @param {DOMElement} target - The event target which mouse-event listeners
  # should be attached to.
  #
  # @param {DOMElement} container - The ink container element, the element
  # within-which the ink will expand.

  initInkMouseEvents: (target, container) ->
    target.addEventListener 'mousedown', (e) =>
      r = container.getBoundingClientRect()
      left = e.clientX - r.left
      top = e.clientY - r.top
      ink = @expandInk(container, left, top, r.width, r.height)

      t = Date.now()

      ## Add an event listener for the mouseup event anywhere, then remove the
      ## listener once the event has occurred.
      fn = (e) =>
        expandsionTime = @inkExpansionTime(r.width, r.height)
        tOffset = expandsionTime + @inkDiffTime - (Date.now() - t)
        @fadeInk(ink, tOffset)
        document.removeEventListener 'mouseup', fn
      document.addEventListener 'mouseup', fn
