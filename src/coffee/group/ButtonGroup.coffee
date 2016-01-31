##
# Defines the ButtonGroup component class.
#
# @author Joshua Toenyes <josh@goatriot.com>

GroupContainer = require 'ui/container/GroupContainer'
template = require 'group/button-group.jad'


##
#
#
# @class ButtonGroup
# @public

module.exports = class ButtonGroup extends GroupContainer

  constructor: ->
    super arguments...

    @classes.push 'sc-button-group'
