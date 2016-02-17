module.exports = (config) ->
  if not process.env.SAUCE_USERNAME or not process.env.SAUCE_ACCESS_KEY
    console.error 'SAUCE_USERNAME and SAUCE_ACCESS_KEY env variables not set.'
    process.exit(1)

  customLaunchers =
    sl_chrome:
      base: 'SauceLabs'
      browserName: 'chrome'
      platform: 'Windows 7'
      version: '35'

    sl_firefox:
      base: 'SauceLabs'
      browserName: 'firefox'
      version: '30'

    sl_ios_safari:
      base: 'SauceLabs'
      browserName: 'iphone'
      platform: 'OS X 10.9'
      version: '7.1'

    sl_ie_11:
      base: 'SauceLabs'
      browserName: 'internet explorer'
      platform: 'Windows 8.1'
      version: '11'

  config.set

    ## Increase timeout in case CI is slow.
    captureTimeout: 4 * 60 * 3000

    sauceLabs:
      testName: 'Stout Core Unit Tests'
      public: 'public'
      build: process.env.TRAVIS_BUILD_NUMBER
      'tunnel-identifier': process.env.TRAVIS_JOB_NUMBER or Date.now()
      connectOptions:
        username: process.env.SAUCE_USERNAME
        accessKey: process.env.SAUCE_ACCESS_KEY
        port: 5757
        logfile: 'sauce_connect.log'

    customLaunchers: customLaunchers

    browsers: Object.keys customLaunchers

    frameworks: ['mocha', 'browserify']

    reporters: ['dots', 'saucelabs']

    files: [
      '../../test/unit/**/*.test.js'
    ]

    preprocessors:
      '../../test/unit/**/*.test.js': ['browserify']
