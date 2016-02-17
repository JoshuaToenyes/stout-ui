# # `bundle`
#
# Bundles this project as defined by the Webpack configuration file.

bundleTaskFactory = require './../helpers/bundle-task-factory'




# @param {Object} config - Build configuration object.
# @param {boolean} uglify - Set to `true` to minify Webpack output using
# UglifyJS.
# @param {boolean} watch - Set to `true` to enable Webpack watching.
# @param {Object} flags- Command line options to output using gulp-help.

module.exports = (config, options, flags) ->

  bundleTaskFactory(
    config, {
      uglify: !options.skipUglifyjs,
      flags: flags.bundle,
      watch: options.watch,
      name: 'bundle',
      description: 'Bundle project files using Webpack.',
      env: 'production',
    })
