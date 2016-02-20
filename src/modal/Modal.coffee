###*
# @overview Defines a basic modal window UI component.
# @module stout-ui/modal/Modal
###

Container = require '../container/Container'
template  = require './modal.template'
backdrop  = require './backdrop'
vars      = require '../vars'


# Load modal variables.
require '../vars/modal'


###*
# The class to add to the root modal container.
# @const
# @type string
# @private
###
MODAL_CLS = vars.read 'modal/modal-class'


###*
# The modal transition-in time in milliseconds.
# @const
# @type number
# @private
###
TRANS_IN_TIME = vars.readTime 'modal/modal-trans-in-time'


###*
# The modal transition-out time in milliseconds.
# @const
# @type number
# @private
###
TRANS_OUT_TIME = vars.readTime 'modal/modal-trans-out-time'



module.exports = class Modal extends Container

  ###*
  # MaskedTextInput constructor.
  #
  # @param {Object} [init] - Initiation object.
  #
  # @exports stout-ui/modal/Modal
  # @extends stout-ui/container/Container
  # @constructor
  ###
  constructor: (init = {}) ->
    super template, null, {renderOnChange: false}, init
    @prefixedClasses.add MODAL_CLS


  ###*
  # Set to `true` if the close "x" should be shown on the modal.
  #
  # @property showClose
  # @type boolean
  # @default true
  # @public
  ###
  @property 'showClose',
    default: true


  ##
  # The modal header's title.
  #
  # @property title
  # @type string
  # @default null
  # @public

  @property 'title'


  ##
  # Opens the modal window. Optionally, a title and modal contents may be
  # passed to this method which will override the existing title and modal.
  # This method is essentially equivalent to calling `#render()` followed by
  # `#show()`.
  #
  # @param {string} [title] - The modal title.
  #
  # @param {string|HTMLElement|ClientView} [contents] - The modal contents.
  #
  # @todo This should return a composed promise.
  #
  # @method open
  # @public

  open: (cb) ->
    @render()
    backdrop().static = true
    backdrop().transitionIn()
    @transitionIn TRANS_IN_TIME, cb


  close: (cb) ->
    backdrop().transitionOut()
    @transitionOut TRANS_OUT_TIME, => @destroy()
