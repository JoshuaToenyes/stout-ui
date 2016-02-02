# # `bundle`
#
# Bundles this project as defined by the Webpack configuration file.

bundleTaskFactory = require './../helpers/bundle-task-factory'
fs                = require 'fs'
gulp              = require('gulp-help')(require 'gulp')




# @param {Object} config - Build configuration object.
# @param {boolean} uglify - Set to `true` to minify Webpack output using
# UglifyJS.
# @param {boolean} watch - Set to `true` to enable Webpack watching.
# @param {Object} flags- Command line options to output using gulp-help.

module.exports = (config, options, flags) ->

  name = 'bundle:example:[name]'
  description = 'Bundle an individually named example using Webpack.'

  gulp.task name, description, ->
    console.error 'You must specify an example.'

  examples = fs.readdirSync process.cwd() + '/example'

  for example in examples
    bundleTaskFactory(
      config, {
        uglify: !options.skipUglifyjs,
        flags: flags.bundle,
        watch: options.watch,
        name: 'bundle:example:' + example,
        description: false,
        env: 'example',
        target: config.path.target.example + '/' + example
        entry: config.path.example.root + '/' + example + '/example.coffee'
        noclean: true
      })
