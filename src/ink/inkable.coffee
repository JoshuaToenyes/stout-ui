###*
# @overview Defines the `inkable` trait, which can be used to add an expanding
# ink effect to a container element.
# @module stout-ui/ink/inkable
###

# Require necessary shared variables.
require '../vars/ink'


###*
# The default ink container class name.
# @type string
# @const
# @private
###
CONTAINER_CLS = vars.readPrefixed 'ink/ink-container-class'


###*
# The class attached to individual ink elements.
# @type string
# @const
# @private
###
INK_CLS = vars.readPrefixed 'ink/ink-class'


###*
# Small time offset to ensure elements are removed/inserted before a CSS
# animation is completed and a static element state is shown (a flash).
#
# @type number
# @const
# @private
###
T_OFFSET = 50


###*
# The amount of time it takes to fade the ink, in milliseconds.
# @type number
# @const
# @private
###
FADE_TIME = vars.readTime 'ink/ink-default-fade-time'


###*
# The inkable trait can be added to a component to create an expanding ink
# effect within some container element.
#
# @exports stout-ui/ink/inkable
# @mixin
###
module.exports =

  ###*
  # Calculates the size the ink should expand to (in pixels) given the passed
  # ink container width and height.
  #
  # @param {number} w - The width of the container element.
  #
  # @param {number} h - The height of the container element.
  #
  # @returns {number} The ink radius.
  #
  # @method calcInkRadius
  # @memberof stout-ui/ink/inkable#
  ###
  calcInkRadius: (w, h) ->
    Math.sqrt(Math.pow(w, 2) + Math.pow(h, 2)) / 0.34


  ###*
  # Creates a DOM element for the ink.
  #
  # @returns {DOMElement} The ink element.
  #
  # @method createInkElement
  # @memberof stout-ui/ink/inkable#
  ###
  createInkElement: ->
    ink = document.createElement 'div'
    inkRun = document.createElement 'div'
    ink.appendChild inkRun
    ink.classList.add INK_CLS
    [ink, inkRun]


  ###*
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
  # @param {function} cb - Optional callback function to call when the ink is
  # expanded.
  #
  # @returns {DOMElement} The ink element.
  #
  # @method expandInk
  # @memberof stout-ui/ink/inkable#
  ###
  expandInk: (el, x, y, w, h, t, cb) ->
    [ink, inkRun] = @createInkElement()
    fillTime = t or @inkExpansionTime(w, h)
    inkRun.style.animationDuration = fillTime + 'ms'
    ink.style.transform = "translateX(#{x}px) translateY(#{y}px)"
    s = @calcInkRadius(w, h)
    ink.style.height = "#{s}px"
    ink.style.width = "#{s}px"
    el.appendChild ink
    if cb then setTimeout cb, fillTime
    ink


  ###*
  # Fades-out the passed ink element
  #
  # @param {DOMElement} ink - The ink element to fade-out.
  #
  # @param {number} t - The number of milliseconds to wait before beginning
  # the fade-out.
  #
  # @param {function} cb - Optional callback function to call when ink has
  # been removed.
  #
  # @method fadeInk
  # @memberof stout-ui/ink/inkable#
  ###
  fadeInk: (ink, t, cb) ->
    ink.classList.add 'fade-out'
    ink.style.transitionDuration = @inkFadeTime + 'ms'
    setTimeout ->
      ink.parentElement?.removeChild ink
      cb?.call null
    , @inkFadeTime + Math.max(t, 0)


  ###*
  # Returns ink within the passed container, if it exists.
  #
  # @param {DOMElement} container - The container from which to get ink.
  #
  # @returns {DOMElement|null} Returnst the ink if present, or `null`.
  #
  # @method getInk
  # @memberof stout-ui/ink/inkable#
  ###
  getInk: (container) ->
    container = container or @getInkContainer()
    container.querySelectorAll ".#{INK_CLS}"


  ###*
  # Returns the ink container element. This method can be overridden for custom
  # functionality.
  #
  # @returns {DOMElement} The ink container
  #
  # @method getInkContainer
  # @memberof stout-ui/ink/inkable#
  ###
  getInkContainer: ->
    @select ".#{CONTAINER_CLS}"


  ###*
  # Checks to see if there is ink in the passed container.
  #
  # @param {DOMElement} container - The container to check if ink is present.
  #
  # @return {boolean} `true` if there is ink in the container.
  #
  # @method hasInk
  # @memberof stout-ui/ink/inkable#
  ###
  hasInk: (container) ->
    @getInk(container)?.length > 0


  ###*
  # Inititates the object using this trait. This method is not added to the
  # object using this trait.
  #
  # @method init
  # @memberof stout-ui/fill/inkable#
  ###
  init: ->
    @viewClasses.inkContainer = CONTAINER_CLS


  ###*
  # Initializes the passed element as an interactive ink element. Ink will
  # expand within the passed element on mousedown, then fade on mouseup.
  #
  # @param {DOMElement} target - The event target which mouse-event listeners
  # should be attached to.
  #
  # @param {DOMElement} [container] - The ink container element, the element
  # within-which the ink will expand.
  #
  # @method initInkMouseEvents
  # @memberof stout-ui/ink/inkable#
  ###
  initInkMouseEvents: (target, container) ->
    if not container then container = @getInkContainer()
    target.addEventListener 'mousedown', (e) =>
      if target.hasAttribute 'disabled' then return
      r = container.getBoundingClientRect()
      left = e.clientX - r.left
      top = e.clientY - r.top
      ink = @expandInk(container, left, top, r.width, r.height)

      t = Date.now()

      # Add an event listener for the mouseup event anywhere, then remove the
      # listener once the event has occurred.
      fn = (e) =>
        expandsionTime = @inkExpansionTime(r.width, r.height)
        tOffset = expandsionTime + T_OFFSET - (Date.now() - t)
        @fadeInk(ink, tOffset)
        document.removeEventListener 'mouseup', fn
      document.addEventListener 'mouseup', fn


  ###*
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
  # @memberof stout-ui/ink/inkable#
  ###
  inkExpansionTime: (w, h) ->
    v = 2
    r = @calcInkRadius(w, h)
    Math.max(r / v, 500)


  ###*
  # The amount of time it should take for the ink to fade out.
  #
  # @member {number} inkFadeTime
  # @memberof stout-ui/ink/inkable#
  ###
  inkFadeTime: FADE_TIME


  ###*
  # Removes all ink from the passed container.
  #
  # @param {DOMElement} container - The container to remove ink from.
  #
  # @method removeInk
  # @memberof stout-ui/ink/inkable#
  ###
  removeInk: (container) ->
    ink = @getInk container
    for i in ink
      i.parentElement?.removeChild i
