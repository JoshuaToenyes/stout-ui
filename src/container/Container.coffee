###*
# @overview Defines the Container class, a generic container.
# @module stout-ui/container/Container
###

ClientViewModel = require 'stout-client/view/ClientViewModel'
Component  = require '../common/Component'
type       = require 'stout-core/utilities/type'
vars       = require '../vars'

# Load container variables.
require '../vars/container'


###*
# Common class name prefix for Stout UI.
# @const
# @type string
# @private
###
PREFIX = vars.read 'common/prefix'


###*
# The non-prefixed class name of the container's content element.
# @const
# @type string
# @private
###
CONTAINER_CLS = vars.read 'container/container-contents-class'



module.exports = class Container extends Component

  ###*
  # A generic container view which may contain an inner-view (or subview) which
  # may be another ClientViewModel, an HTMLElement, or a string (HTML or text).
  #
  #  module:stout-ui/common/Component
  #
  # @extends stout-ui/common/Component
  # @exports stout-ui/container/Container
  # @constructor
  ###
  constructor: ->
    super arguments...


  ###*
  # The contents to be rendered within the container.
  #
  # @member contents
  # @memberof stout-ui/container/Container#
  # @type string|HTMLElement|stout-client/view/ClientViewModel
  ###
  @property 'contents',
    serializable: false
    get: (c) ->
      if c instanceof ClientViewModel
        c.render()
      else
        c

  ###*
  # This property holds the name of the container contents class, which can
  # be used in the container's template to specify which element should hold
  # the contents.
  #
  # @member contentsClassName
  # @memberof stout-ui/container/Container#
  # @type string
  ###
  @property 'contentsClassName',
    value: PREFIX + CONTAINER_CLS
    const: true


  ###*
  # Renders the container.
  #
  # @param {string|HTMLElement|ClientViewModel} [contents] - Optional content. If
  # defined, then the `contents` property is set to the passed value before
  # the view is rendered.
  #
  # @returns {HTMLElement} Root element of rendered content.
  #
  # @method render
  # @memberof stout-ui/container/Container#
  ###
  render: (contents) ->
    super()
    if contents then @contents = contents
    cc = @select ".#{@contentsClassName}"
    if type(@contents).isHTMLElement()
      cc.innerHTML = ''
      cc.appendChild @contents
    else
      cc.innerHTML = @contents
    @root
