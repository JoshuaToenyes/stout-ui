# # gulpfile.coffee
#
# This gulpfile defines build and development tasks for the Stout Client
# development, production, and test environments. It uses a combination of basic
# gulp task names and command line flags. The command `gulp help` can be used
# to display a list of commands intended to be used by the developer.
#
#
# ## Gulp and Build System Strategy
#
# The overall goal of using `gulp` and the build system is to simplify the
# build and development process and separate as many build tasks as possible to
# keep things neatly organized and parameterized using the
# [build.yaml](config/build.html) configuration file. **There shouldn't be
# any paths or magic constants in this file, or any task file. Any parameters
# should be moved to the `build.yaml` configuration file.**
#
#
# ## Build Configuration
#
# The build configuration file, [build.yaml](config/build.html), provides
# the configuration parameters for build tasks. If a task has options available
# they should be defined in the `build.yaml` file. Additionally, *everything*
# should be as DRY as possible. If a configuration task shares many options and
# parameters with another task, they're a good candidate to be combined, or
# to share configuration options.
#
#
# ## Tasks
#
# Tasks are defined in their own files and loaded dynamically by this Gulpfile.
# All task files are in the `build/tasks/` folder and loaded from there. **No
# tasks should be defined in this Gulpfile.**
#
#
# ### CoffeeScript Compilation Tasks
#
# CoffeeScript tasks are prefixed with `coffee`. They are responsible for the
# compilation (or transpilation) of CoffeeScript to Javascript.
#
#
# ### JavaScript Bundling Tasks
#
# Bundling tasks are prefixed with `bundle`. These tasks handle the bundling
# of distinct JavaScript files in to a single combined, or set of JavaScript
# files. Bundling is accomplished using the
# [Webpack Module Bundler](https://webpack.github.io/). Webpack is a very
# powerful tool and has a huge number of options and configurations. The
# Webpack website should be consulted for available options and configuration
# parameters. This project's Webpack configuration is specified in the
# [build/config/webpack.config.coffee](/build/config/webpack.config.html)
# configuration file.
#
#
# ### Cleaning Tasks
#
# Cleaning tasks perform general cleanup by removing build files or
# temporary files and directories. These tasks are prefixed with `clean`.
#
#
# ### Build Tasks
#
# Build tasks are prefixed with `build` and perform a series of tasks to build
# this project for some environment (production, testing, etc.).
#
#
# ### Chore Tasks
#
# General chore-related tasks such as `bump` or `tag` are for helping with
# git repository or publishing related tasks.
#
#
# ### Documentation Tasks
#
# Tasks to build and serve project documentation are prefixed with `doc`.
# Documentation is generated using a fork of
# [Groc](http://nevir.github.io/groc/), a literate-programming style
# documentation tool.
#
#
# ### Lint Tasks
#
# Linting tasks are responsible for enforcing source file stylistic standards.
# Every software project benefits from clean and standardized source code, and
# lint performs an important role in ensuring the source code adheres to a
# minimum quality standard.
#
#
# ### Testing Tasks
#
# These tasks focus on building and running the various types of tests for
# this project. There are several testing tasks available, all of which
# offer some type of coverage vs. speed trade-off. Testing tasks are prefixed
# with `test`.
#
#
# ### Local Web-server Tasks
#
# These tasks run a web-server to serve project files, test files, or assist
# with development. Additionally, the build-system web server is used remotely
# by Travis CI and Sauce Labs.



_           = require 'lodash'
fs          = require 'fs'
gulp        = require('gulp-help')(require 'gulp')
path        = require 'path'
watch       = require 'gulp-watch'
yaml        = require 'js-yaml'
yargs       = require 'yargs'


#- Grab command line arguments.
argv = yargs.argv


#- Load and parse the build configuration.
config = yaml.safeLoad fs.readFileSync __dirname + '/config/build.yaml'


#- Default all config options, then remove the `default` key.
_.forEach config.env, (value, key) ->
  if key is 'default' then return
  _.defaultsDeep config.env[key], config.env.default
config.env = _.omit config.env, 'default'


#- Set the build environment based on command line flags (default to "debug").
env = 'debug'
_.forEach ['production', 'test'], (v) ->
  if argv[v] then env = v


#- Freeze the config object to ensure we don't inadvertently alter it.
Object.freeze config


#- Command-line flags.
flags =

  lint:
    'fail-on-error': 'Causes a non-zero exit code when an error is encountered.'
    'watch': 'Watch and re-lint on source or test file changes.'

  bundle:
    'skip-uglifyjs': 'Skip compression with UglifyJS.'
    'watch': 'Watch and re-bundle on source or test file changes.'


## Options passed to tasks.
options =

  watch: argv.watch

  skipUglifyjs: argv.skipUglifyjs

  failOnError: argv.failOnError


## Require all tasks in the `build/tasks` folder.
try
  tasks = fs.readdirSync "#{__dirname}/tasks"

  for task in tasks
    task = path.basename task, '.coffee'
    require("#{__dirname}/tasks/#{task}")(config, options, flags)

catch e
  console.error 'Problem loading Gulp tasks.'
  throw e