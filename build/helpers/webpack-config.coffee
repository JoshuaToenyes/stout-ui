###
# # Webpack Build Configuration Helper
#
# Helper function which parses and returns Webpack configuration and entry
# points based on the passed parameters.
###

_       = require 'lodash'
webpack = require 'webpack-stream'



###
# @function module.exports(config, uglify, env, watch)
#
# @param {Object} config - Build configuration object.
#
# @param {boolean} uglify - `true` if the Webpack bundle should be minified
# using UglifyJS.
#
# @param {string} env - String environment description, e.g. `test`.
#
# @param {boolean} watch - `true` to enable Webpack "watch" mode.
###
module.exports = (config, uglify, env, watch) ->

  # Load the webpack config file.
  webpackConfig = require __dirname + '/../config/webpack.config.coffee'
  webpackConfig.plugins ?= []

  # Grab Webpack plugin references.
  UglifyJsPlugin = webpack.webpack.optimize.UglifyJsPlugin

  # Merge-in the environment configuration.
  _.merge webpackConfig, config.env[env].webpack

  if uglify
    webpackConfig.plugins.push new UglifyJsPlugin(config.env[env].uglify)

  if watch
    webpackConfig.watch = true

  [webpackConfig, config.env[env].entry]
