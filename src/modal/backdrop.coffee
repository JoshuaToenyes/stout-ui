###*
# @overview Defines the Backdrop class and it's singleton interface.
# @module modal/backdrop
###

Interactive = require '../common/Interactive'
vars        = require '../vars'


# Load common and modal variables.
vars.default('modal', require '../vars/modal')


###*
# The backdrop classname postfix.
# @private
###
BACKDROP_CLASS = vars.read 'modal/backdrop-class'

TRANS_IN_TIME = vars.readTime 'modal/backdrop-trans-in-time'
TRANS_OUT_TIME = vars.readTime 'modal/backdrop-trans-out-time'

class Backdrop extends Interactive

  ###*
  #
  #
  # @class modal/Backdrop
  ###
  constructor: ->
    super (-> ''), null, {renderOnChange: false}
    @prefixedClasses.add BACKDROP_CLASS
    @parentEl = document.body
    @render()
    @static = true


  @property 'static',
    default: true
    set: (s) ->
      @_static = !!s
      if @_static
        @on 'click', @_clickHandler, @
      else
        @off 'click', @_clickHandler
    get: -> @_static





  _clickHandler: ->
    if @visible then @transitionOut()

  transitionIn: (cb) -> super TRANS_IN_TIME, cb

  transitionOut: (cb) -> super TRANS_OUT_TIME, cb




instance = null

module.exports = ->
  if instance is null then instance = new Backdrop()
  instance
