var path = require('path');
var coffeeCoverage = require('coffee-coverage');
var projectRoot = path.resolve(__dirname, "../../coverage");
var coverageVar = coffeeCoverage.findIstanbulVariable();
var writeOnExit = (coverageVar == null) ? (projectRoot + '/coverage/coverage-coffee.json') : null;

coffeeCoverage.register({
    instrumentor: 'istanbul',
    basePath: projectRoot,
    exclude: ['test'],
    coverageVar: coverageVar,
    writeOnExit: writeOnExit,
    initAll: true
});
