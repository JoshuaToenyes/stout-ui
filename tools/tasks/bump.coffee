# # `bump:[patch, minor, major]`
#
# Bumps the patch, minor, or major version of this package. These tasks are all
# virtually identical except for the hierarchical difference, so a simple
# function is used to generate all Gulp tasks.

bump = require 'gulp-bump'
git  = require 'gulp-git'
gulp = require('gulp-help')(require 'gulp')
forEach = require 'lodash/forEach'
tag  = require 'gulp-tag-version'



module.exports = ->

  forEach {
    patch: 'Bump, commit, and tag the package patch version.'
    minor: 'Bump, commit, and tag the package minor version.'
    major: 'Bump, commit, and tag the package major version.'
  }, (description, importance) ->
    gulp.task importance, description, ->
      gulp.src ['./package.json']
      .pipe bump({type: importance})
      .pipe gulp.dest './'
      .pipe git.commit "Bump package #{importance} version."
      .pipe tag()
