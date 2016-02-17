###

clean:target Gulp Task

Removes transpiled folders from project root, which removes all JavaScript
source files and source maps. This is accomplished by scanning the src directory
then removing matching files and folders from the project root.

###

del  = require 'del'
gulp = require('gulp-help')(require 'gulp')
fs   = require 'fs'
path = require 'path'



module.exports = (config) ->

  gulp.task 'clean:target', false, ->
    try
      source = fs.readdirSync config.path.src
      for item in source
        if item[0] is '.' then continue
        if path.extname(item) is '.coffee'
          item = path.basename(item, '.coffee') + '.js'
        del [config.path.target + '/' + item]
    catch e
      console.error 'Can\'t reading source directory!'
      throw e
