###*
# @overview Defines a component which can be "affixed" to some other component,
# keeping it positioned around the element to-which it's affixed.
#
# @module stout-ui/traits/Affixable
###
Foundation     = require 'stout-core/base/Foundation'
isString       = require 'lodash/isString'
positionString = require 'stout-client/util/positionString'
vars           = require '../vars'
View           = require 'stout-client/view/View'

# Require shared variables.
require '../vars/affixable'


###*
# Class applied to Affixable components.
#
# @type string
# @const
# @private
###
AFFIXABLE_CLASS = vars.readPrefixed 'affixable/affixable-class'



###*
# The Affixable trait allows a component to be "fixed" to some other element,
# positioning it relative to the element to-which it's "affixed" to.
#
# @exports stout-ui/traits/Affixable
# @mixin
###
module.exports = class Affixable extends Foundation

  ###*
  # The axis to affix inside. By default, the affixable will be positioned
  # outside the element it's affixed to.
  #
  # @member {string} affixInside
  # @member stout-ui/trait/Affixable#
  ###
  @property 'affixInside',
    default: ''
    type: 'string'
    values: ['x', 'y', 'both', '']


  ###*
  # The position to render this Affixable, relative it it's `affixTo` target.
  # This should be a string of the form, "center center", "top center",
  # "top left", etc.
  #
  # @member {string} affixPosition
  # @memberof stout-ui/traits/Affixable#
  ###
  @property 'affixPosition',
    default: 'top left'
    type: 'string'


  ###*
  # The target element or view which this Affixable should be "affixed" to. If
  # it's a string, it's interpreted as a CSS selector, if it's an instance of
  # a View, it's affixed to the view's root element, otherwise it should be
  # an HTMLElement.
  #
  # @member {string|module:stout-client/view/View|HTMLElement} affixTo
  # @memberof stout-ui/traits/Affixable#
  ###
  @property 'affixTo',
    default: 'body'
    set: (target) ->
      if isString target
        document.querySelector(target)
      else if target instanceof View
        @__affixView = target
        target.root
      else
        target


  ###*
  # Boolean indicating if the Affixable should "slide" to keep it in-view.
  #
  # @member {string} slideAffixable
  # @memberof stout-ui/traits/Affixable#
  ###
  @property 'slideAffixable',
    default: true
    type: 'boolean'


  ###*
  # Boolean indicating if the position of the affixable should be swappable, or
  # should not "swap" to the other side when it is rendered out-of-view.
  #
  # @member {string} swapAffixable
  # @memberof stout-ui/traits/Affixable#
  ###
  @property 'swapAffixable',
    default: true
    type: 'boolean'


  ###*
  # Positions the affixed view to the target.
  #
  # @method __affix
  # @memberof stout-ui/traits/Affixable#
  # @private
  ###
  __affix: (force) ->
    targetR = @affixTo.getBoundingClientRect()
    r = @root.getBoundingClientRect()

    [posX, posY] = positionString(force or @affixPosition)
    cs = getComputedStyle @root

    targetCenterX = (targetR.left + targetR.right) / 2
    targetCenterY = (targetR.top + targetR.bottom) / 2

    mtop    = parseInt(cs.marginTop)
    mbottom = parseInt(cs.marginBottom)
    mleft   = parseInt(cs.marginLeft)
    mright  = parseInt(cs.marginRight)
    xmargin = mleft + mright
    ymargin = mtop + mbottom

    centerX = targetCenterX - r.width / 2 - xmargin / 2
    centerY = targetCenterY - r.height / 2 - ymargin / 2

    if @affixInside is 'x' or @affixInside is 'both'
      switch posX
        when 'left'   then left = targetR.left - mleft
        when 'right'  then left = targetR.right - r.width - (mleft + mright)
        when 'center' then left = centerX
    else
      switch posX
        when 'left'   then left = targetR.left - r.width - (mleft + mright)
        when 'right'  then left = targetR.right
        when 'center' then left = centerX

    if @affixInside is 'y' or @affixInside is 'both'
      switch posY
        when 'top'    then top = targetR.top
        when 'bottom' then top = targetR.bottom - r.height - ymargin
        when 'center' then top = centerY
    else
      switch posY
        when 'top'    then top = targetR.top - r.height - ymargin
        when 'bottom' then top = targetR.bottom
        when 'center' then top = centerY

    # Calculate booleans flags to indicate if affixible would be off-screen.
    offScreenLeft   = left + mleft < 0
    offScreenRight  = left + r.width + mleft > window.innerWidth
    offScreenTop    = top + mtop < 0
    offScreenBottom = top + r.height + mbottom > window.innerHeight

    # Update calculated positions to keep "slideable" affixables in-view.
    if @slideAffixable and posY isnt 'center'
      if offScreenLeft
        left = Math.min(-mleft, targetR.right)
      if offScreenRight
        left = Math.max(window.innerWidth - r.width - mleft,
        targetR.left - r.width - mright - mleft)

    if @slideAffixable and posX isnt 'center'
      if offScreenTop
        top = Math.min(-mtop, targetR.bottom)
      if offScreenBottom
        top = Math.max(window.innerHeight - r.height - mtop,
        targetR.top - r.height - mtop - mbottom)

    # If the affixable is positioned at the center (x or y axes), and it goes
    # off-screen, let's swap it to the other side of the target. This keeps it
    # on-screen as long as possible.
    if @swapAffixable and not force and
    (posY is 'center' or posX is 'center')
      if posX is 'right' and offScreenRight
        return @__affix "left center"
      if posX is 'left' and offScreenLeft
        return @__affix "right center"
      if posY is 'bottom' and offScreenBottom
        return @__affix "top center"
      if posY is 'top' and offScreenTop
        return @__affix "bottom center"

    # Position the component's root element as calculated.
    @root.style.left = "#{left}px"
    @root.style.top = "#{top}px"


  ###*
  # Initiates the Affixable component.
  #
  # @method initTrait
  # @memberof stout-ui/traits/Affixable#
  ###
  initTrait: ->
    @classes.add AFFIXABLE_CLASS

    affix = => @__affix()

    @on 'show', affix
    @on 'change:affixPosition', affix
    @addEventListenerTo window, 'scroll', affix
    @addEventListenerTo window, 'resize', affix

    if @__affixView and @__affixView.eventRegistered 'drag'
      @__affixView.on 'drag', affix
