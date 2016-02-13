# # `clean:target`
#
# Removes compiled files from the target directory.

del  = require 'del'
gulp = require('gulp-help')(require 'gulp')
fs   = require 'fs'
path = require 'path'


# @param {Object} config - Build configuration object.

module.exports = (config) ->

  gulp.task 'clean:target', 'Clean compiled files from target directory.', ->
    try
      source = fs.readdirSync config.path.src
      for item in source
        if item[0] is '.' then continue
        if path.extname(item) is '.coffee'
          item = path.basename(item, '.coffee') + '.js'
        del [config.path.target + '/' + item]
    catch e
      console.error 'Problem reading source directory.'
      throw e
