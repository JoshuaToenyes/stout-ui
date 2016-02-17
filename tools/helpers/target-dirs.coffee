fs   = require 'fs'
path = require 'path'

module.exports = (config) ->

  source = fs.readdirSync config.path.src
  dirs = []

  for item in source
    if item[0] is '.' then continue
    if path.extname(item).length is 0
      dirs.push item

  dirs
