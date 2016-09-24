###*
# @overview Registers the custom modal tag provides the modal factory.
#
# @module stout-ui/modal
###
defaults  = require 'lodash/defaults'
Modal     = require './Modal'
ModalView = require './ModalView'
parser    = require 'stout-client/parser'

# Read the button custom HTML tag.
TAG_NAME = vars.readPrefixed 'modal/modal-tag'

# Register the button tag.
parser.register TAG_NAME, ModalView, Modal

module.exports =

  create: (init) ->
    defaults init, {context: new Modal}
    (new ModalView init).context
