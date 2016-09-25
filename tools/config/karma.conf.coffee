module.exports = (config) ->

  config.set
    browsers: ['Chrome']#, 'Safari', 'PhantomJS', 'Firefox']

    frameworks: ['browserify', 'mocha', 'chai-sinon']

    reporters: ['mocha']

    files: [
      '../../test/unit/**/*.test.js'
    ]

    preprocessors:
      '../../test/unit/**/*.test.js': ['browserify']
