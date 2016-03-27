###*
# @overview Defines the SelectableViewTrait which can be added to a view or
# view component to make it "selectable."
#
# @module stout-ui/interactive/SelectableViewTrait
###
Foundation = require 'stout-core/base/Foundation'


# Require necessary shared variables.
require '../vars/select'


###*
# Class applied to root element indicating this view is selected.
# @type string
# @const
# @private
###
SELECTED_CLS = vars.readPrefixed 'select/select-selected-class'


###*
# The `SelectableViewTrait` defines a view or view component which may be
# "selected" and "unselected" based on user interaction.
#
# @exports stout-ui/interactive/SelectableViewTrait
# @mixin
###
module.exports = class SelectableViewTrait extends Foundation

  ###*
  # Property indicating if this view is selected.
  #
  # @member selected
  # @memberof stout-ui/select/SelectableViewTrait#
  # @type boolean
  ###
  @property 'selected',
    default: false



  ###*
  # Handles a selected-change event.
  #
  # @method _onSelectedChange
  # @memberof stout-ui/select/SelectableViewTrait#
  # @private
  ###
  _onSelectedChange: ->
    if @selected
      @classes.add SELECTED_CLS
    else
      @classes.remove SELECTED_CLS


  ###*
  # Initiates this trait by syncing the `selected` properties with this view's
  # context and adding appropriate events. Also handles the case of an initial
  # selection, i.e. `selected` is set to `true` at instantiation.
  #
  # @method initTrait
  # @memberof stout-ui/select/SelectableViewTrait#
  # @private
  ###
  initTrait: ->
    @syncProperty @context, 'selected', {inherit: false}
    @on 'change:selected', @_onSelectedChange, @
    @_onSelectedChange()


  ###*
  # Toggles the selected value of this view.
  #
  # @method toggleSelected
  # @memberof stout-ui/select/SelectableViewTrait#
  ###
  toggleSelected: ->
    @selected = not @selected
