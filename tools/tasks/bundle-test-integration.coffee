# # `bundle:test:integration`
#
# Bundles this project as defined by the Webpack configuration file.

bundleTaskFactory = require './../helpers/bundle-task-factory'



# @param {Object} config - Build configuration object.
#
# @param {Object} options - Task option specifications.
#
# @param {Object} flags- Command line options to output using gulp-help.

module.exports = (config, options, flags) ->

  bundleTaskFactory(
    config, {
      uglify: !options.skipUglifyjs,
      flags: flags.bundle,
      name: 'bundle:test:integration',
      description: 'Bundle integration tests using Webpack.',
      env: 'integration',
    })
