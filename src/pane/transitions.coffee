###*
# @module stout-ui/pane/transitions
###


###*
# Translation coordinates as `x, y` pixels from the screen's upper left.
# @typedef {Array.<number, number>} Coordinates
###


###*
# Translation dimensions in `width, height` pixels.
# @typedef {Array.<number, number>} Dimensions
###

module.exports =

  ###*
  # The fade transition appears here only as a place holder. This transition
  # is entirely defined in CSS.
  #
  # @member fade
  # @memberof stout-ui/pane/transitions
  ###
  fade: require './fade'

  overlay: require './overlay'

  zoom: require './zoom'
