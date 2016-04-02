###*
# @overview Defines the Pane component view model.
#
# @module stout-ui/pane/Pane
###
Component = require '../component/Component'



module.exports = class Pane extends Component

  constructor: ->
    super arguments...

  ###*
  # Transition type.
  #
  # @member transition
  # @memberof stout-ui/pane/Pane#
  # @public
  ###
  @property 'transition',
    default: 'fade'
    values: [
      'fade'
      'zoom'
      'overlay'
    ]


  ###*
  # Transition start, e.g. where the pane starts-from when it
  # transitions-in. Only valid for `overlay` transition type.
  #
  # @member start
  # @memberof stout-ui/pane/Pane#
  # @public
  ###
  @property 'start',
    values: [
      null
      'top'
      'right'
      'bottom'
      'left'
    ]


  ###*
  # Transition end, e.g. where the pane animates-to when it
  # transitions-out. Only valid for `overlay` transition type.
  #
  # @member end
  # @memberof stout-ui/pane/Pane#
  # @public
  ###
  @property 'end',
    values: [
      null
      'top'
      'right'
      'bottom'
      'left'
    ]


  ###*
  # The preferred width of the pane in pixels. May also be set to "auto" to
  # attempt to automatically determine the size of the pane or "full" to fill
  # the viewport.
  ###
  @property 'width',
    default: 'full'


  ###*
  # The preferred height of the pane in pixels. May also be set to "auto" to
  # attempt to automatically determine the size of the pane or "full" to fill
  # the viewport.
  ###
  @property 'height',
    default: 'full'
