_           = require 'lodash'
dom         = require 'core/utilities/dom'
Input       = require 'ui/common/Input'
template    = require 'input/text-input.jade'


##
# Simple text input.
#
module.exports = class TextInput extends Input

  @property 'placeholder',
    default: ''


  constructor: (model, init = {}) ->
    super template, model, {renderOnChange: false}, init

    @on 'change:placeholder', =>
      if @rendered then @_getInputTarget().placeholder = @placeholder
