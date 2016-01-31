_                 = require 'lodash'
fs                = require 'fs'
path              = require 'path'
yaml              = require 'js-yaml'
HtmlWebpackPlugin = require 'html-webpack-plugin'
RewirePlugin      = require 'rewire-webpack'



# Load and parse the build configuration.
config = yaml.safeLoad fs.readFileSync __dirname + '/build.yaml'



# Export our Webpack configuration.
module.exports =

  # Disable error tolerance and cause Webpack to exit with a non-zero exit code
  # on the first error. This is especially useful with CI systems which monitor
  # exit codes to valid builds, etc.
  # @see https://webpack.github.io/docs/configuration.html#bail
  bail: true

  # The base directory for resolving the entry option.
  context: "#{__dirname}/../../"


  # Various output options, to give us a single bundle.js file with everything
  # resolved and concatenated.
  # @see https://webpack.github.io/docs/configuration.html#output
  output:
    sourceMapFilename: '[file].map'


  # Where to resolve our loaders.
  resolveLoader:
    modulesDirectories: ['node_modules']


  # Options which affect the resolution of modules.
  # @see https://webpack.github.io/docs/configuration.html#resolve
  resolve:

    modulesDirectories: ['node_modules']

    # Directories that contain our modules
    root: [
      "#{__dirname}/../../#{config.path.src.coffee}"
      "#{__dirname}/../../#{config.path.test.unit}"
      "#{__dirname}/../../#{config.path.test.integration}"
      "#{__dirname}/../../#{config.path.test.selenium}"
      "#{__dirname}/../../node_modules"
      "#{__dirname}/../../#{config.path.src.sass}"
      "#{__dirname}/../../#{config.path.src.templates}"
      "#{__dirname}/../../#{config.path.assets}"
    ]

    # Extensions used to resolve modules.
    extensions: ['', '.js', '.coffee', '.jade']

    # Replace modules with other modules or paths (like the 'paths' option
    # with Require.js). This is for modules where we explicitly control the
    # location, as opposed to node_modules based modules.
    # @see https://webpack.github.io/docs/configuration.html#resolve-alias
    alias:
      core:   'stout-core/src/coffee'
      client: 'stout-client/src/coffee'
      ui:     "#{__dirname}/../../#{config.path.src.coffee}"


  # These are external modules that should not be bundled by Webpack.
  externals: [
    {
      'mock-browser': 'require("mock-browser")'
    }
  ]


  # Source map option.
  # @see https://webpack.github.io/docs/configuration.html#devtool
  devtool: 'source-map'


  # Our configured loaders.
  module:
    loaders: [
      {
        test: /\.coffee$/,
        loader: 'coffee-loader'
      }
      {
        test: /\.jade$/,
        exclude: /\.html\.jade$/,
        loader: 'jade-loader'
      }
      {
        test: /\.html\.jade$/,
        loaders: ['file?name=index.html', 'jade-html']
      }
      {
        test: /\.(jpe?g|png|gif|svg)$/i
        loaders: [
          'file?hash=sha512&digest=hex&name=[hash].[ext]'
          'image-webpack?bypassOnDebug&optimizationLevel=7&interlaced=false']
      }
      {
        test: /\.sass$/
        exclude: /\.useable\.sass$/
        loaders: [
          'style',
          'css-loader?sourceMap',
          'sass?sourceMap&indentedSyntax=true']
      }
      {
        test: /\.scss$/
        exclude: /\.useable\.scss$/
        loaders: [
          'style',
          'css-loader?sourceMap',
          'sass?sourceMap']
      }
      {
        test: /\.useable\.sass$/
        loaders: [
          'style/useable',
          'css-loader?sourceMap',
          'sass?sourceMap=true&sourceMapContents=true&indentedSyntax=true&sourceMapEmbed=true']
      }
      {
        test: /\.useable\.scss$/
        loaders: [
          'style/useable',
          'css-loader?sourceMap',
          'sass?sourceMap=true&sourceMapContents=true&sourceMapEmbed=true']
      }
    ]


  # Webpack plugin configuration.
  plugins: [

    # Creates a simple index.html file which includes the entry-point bundles.
    # @see https://github.com/ampedandwired/html-webpack-plugin
    new HtmlWebpackPlugin()

    # Use the rewire mocking plugin in Webpack plugins.
    # @see https://github.com/jhnns/rewire
    # @see https://github.com/jhnns/rewire-webpack
    new RewirePlugin()
  ]


  # Include mocks for when node.js specific modules may be required
  node:
    fs: 'empty',
    net: 'empty',
    tls: 'empty'

