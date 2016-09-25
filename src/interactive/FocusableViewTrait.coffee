###*
# @overview Defines the `FocusableViewTrait` which can make any view or
# component focusable.
#
# @module stout-ui/intractive/FocusableViewTrait
###
Foundation          = require 'stout-core/base/Foundation'
EnableableViewTrait = require '../interactive/EnableableViewTrait'


module.exports = class FocusableViewTrait extends Foundation

  @property 'tabIndex',
    default: 0
    type: 'number'


  _setTabIndex: ->
    if @usingTrait(EnableableViewTrait) and @disabled
      index = -1
    else
      index = @tabIndex
    @root.tabIndex = index


  initTrait: ->
    @on 'ready change:tabIndex', @_setTabIndex, @
    if @usingTrait EnableableViewTrait
      @on 'enable disable', @_setTabIndex, @
