module.exports = (config) ->

  config.set
    browsers: ['Chrome']
    frameworks: ['mocha']
    reporters: ['progress']
    files: [
      './../../dist/*.js'
    ]
