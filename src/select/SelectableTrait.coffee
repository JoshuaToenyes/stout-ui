###*
# @overview Defines the `SelectableTrait`, a selectable view-model likely paired
# with a view using `SelectableTrait`.
#
# @module stout-ui/select/SelectableTrait
###
EnableableTrait = require '../interactive/EnableableViewTrait'
Foundation      = require 'stout-core/base/Foundation'



module.exports = class SelectableTrait extends Foundation

  ###*
  # Property indicating if this view is selected, synced by the view. If using
  # the EnableableTrait and this view is not enabled, then do not change the
  # value of `selected`.
  #
  # @member {boolean} selected
  # @memberof stout-ui/select/SelectableTrait#
  ###
  @property 'selected',
    default: false
    type: 'boolean'
    set: (select) ->
      if @usingTrait(EnableableTrait) and not @enabled
        @selected
      else
        select


  ###*
  # Initiates this trait by syncing the `selected` properties with this view's
  # context and adding appropriate events.
  #
  # @method initTrait
  # @memberof stout-ui/select/SelectableTrait#
  # @private
  ###
  initTrait: ->
    @registerEvents ['select', 'unselect', 'toggleselect']
    @on 'change:selected', (e) ->
      if e.data.value is true
        @fire 'select'
      else
        @fire 'unselect'


  ###*
  # Select this view.
  #
  # @method select
  # @memberof stout-ui/select/SelectableTrait#
  ###
  select: -> @selected = true


  ###*
  # Select this view.
  #
  # @method select
  # @memberof stout-ui/select/SelectableTrait#
  ###
  unselect: -> @selected = false


  ###*
  # Toggles this view's selected status.
  #
  # @method toggleSelected
  # @memberof stout-ui/select/SelectableTrait#
  ###
  toggleSelected: ->
    @selected = not @selected
    @fire('toggleselect')
