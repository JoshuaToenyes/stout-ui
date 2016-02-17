targets = require './target-dirs'

module.exports = (config) ->
  tpath = config.path.target
  "#{tpath}/#{target}/**/*.js" for target in targets(config)
