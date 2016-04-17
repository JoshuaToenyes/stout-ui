
/**
 *
 *
 *
 *
 */

(function() {
  var BUILT_IN_VALIDATORS, HasValidationStates, IllegalArgumentErr, Map, k, keys, merge, msgsRegExp, parseMessages, parseValidator, states, v, validators;

  IllegalArgumentErr = require('stout-core/err').IllegalArgumentErr;

  HasValidationStates = require('stout-core/traits/HasValidationStates');

  keys = require('lodash/keys');

  Map = require('stout-core/collection/Map');

  merge = require('lodash/merge');

  BUILT_IN_VALIDATORS = {
    'max': require('stout-core/validators/Max'),
    'min': require('stout-core/validators/Min'),
    'size': require('stout-core/validators/Size'),
    'required': require('stout-core/validators/Required')
  };

  validators = new Map();

  for (k in BUILT_IN_VALIDATORS) {
    v = BUILT_IN_VALIDATORS[k];
    validators.put(k, v);
  }

  states = keys(HasValidationStates.STATES).join('|');

  msgsRegExp = new RegExp("(" + states + ")\\[([^\\]]+)\\]", 'g');


  /**
   * Parses-out messages from validator descriptor.
   *
   * @param {string} - Validator descriptor.
   *
   * @returns {Object} Messages object keyed by validator state.
   *
   * @function parseMessages
   * @inner
   */

  parseMessages = function(v) {
    var msgs, res;
    msgs = {};
    while ((res = msgsRegExp.exec(v)) !== null) {
      if (res.length >= 3) {
        msgs[res[1]] = res[2];
      }
    }
    return msgs;
  };


  /**
   * Parses and instantiates the validator.
   *
   * @param {string} - Validator descriptor.
   *
   * @
   *
   */

  parseValidator = function(v) {
    var args, cls;
    v = v.split(':');
    cls = validators.get(v[0]);
    if (!cls) {
      throw new IllegalArgumentErr("Validator \"" + v[0] + "\" does not exist or is not registered.");
    }
    if (v[1]) {
      args = v[1].split(',').map(function(s) {
        return s.trim();
      });
    } else {
      args = [];
    }
    return new (Function.prototype.bind.apply(cls, [null].concat(args)));
  };


  /**
   * Parses a validator string and instantiates the appropriate Validator classes.
   *
   * @exports stout-ui/validators/parser
   * @function parser
   */

  module.exports.parse = function(s) {
    var i, len, val, vals, vs;
    vs = s.split('|');
    vals = [];
    for (i = 0, len = vs.length; i < len; i++) {
      v = vs[i];
      v = v.trim();
      if (v.length === 0) {
        continue;
      }
      val = parseValidator(v);
      merge(val.messages, parseMessages(v));
      vals.push(val);
    }
    return vals;
  };


  /**
   * The validators map which can be added-to for extending the parser's vocabulary
   * of validators.
   *
   * @exports stout-ui/validators/parser.validators
   */

  module.exports.validators = validators;

}).call(this);

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbInZhbGlkYXRvcnMvcGFyc2VyLmNvZmZlZSJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiO0FBQUE7Ozs7Ozs7QUFBQTtBQUFBLE1BQUE7O0VBTUEsa0JBQUEsR0FBc0IsT0FBQSxDQUFRLGdCQUFSLENBQXlCLENBQUM7O0VBQ2hELG1CQUFBLEdBQXNCLE9BQUEsQ0FBUSx1Q0FBUjs7RUFDdEIsSUFBQSxHQUFzQixPQUFBLENBQVEsYUFBUjs7RUFDdEIsR0FBQSxHQUFzQixPQUFBLENBQVEsMkJBQVI7O0VBQ3RCLEtBQUEsR0FBc0IsT0FBQSxDQUFRLGNBQVI7O0VBR3RCLG1CQUFBLEdBQ0U7SUFBQSxLQUFBLEVBQVksT0FBQSxDQUFRLDJCQUFSLENBQVo7SUFDQSxLQUFBLEVBQVksT0FBQSxDQUFRLDJCQUFSLENBRFo7SUFFQSxNQUFBLEVBQVksT0FBQSxDQUFRLDRCQUFSLENBRlo7SUFHQSxVQUFBLEVBQVksT0FBQSxDQUFRLGdDQUFSLENBSFo7OztFQU1GLFVBQUEsR0FBaUIsSUFBQSxHQUFBLENBQUE7O0FBRWpCLE9BQUEsd0JBQUE7O0lBQ0UsVUFBVSxDQUFDLEdBQVgsQ0FBZSxDQUFmLEVBQWtCLENBQWxCO0FBREY7O0VBSUEsTUFBQSxHQUFTLElBQUEsQ0FBSyxtQkFBbUIsQ0FBQyxNQUF6QixDQUFnQyxDQUFDLElBQWpDLENBQXNDLEdBQXRDOztFQUNULFVBQUEsR0FBaUIsSUFBQSxNQUFBLENBQU8sR0FBQSxHQUFJLE1BQUosR0FBVyxrQkFBbEIsRUFBcUMsR0FBckM7OztBQUVqQjs7Ozs7Ozs7Ozs7RUFVQSxhQUFBLEdBQWdCLFNBQUMsQ0FBRDtBQUNkLFFBQUE7SUFBQSxJQUFBLEdBQU87QUFDUCxXQUFNLENBQUMsR0FBQSxHQUFNLFVBQVUsQ0FBQyxJQUFYLENBQWdCLENBQWhCLENBQVAsQ0FBQSxLQUErQixJQUFyQztNQUNFLElBQUcsR0FBRyxDQUFDLE1BQUosSUFBYyxDQUFqQjtRQUF3QixJQUFLLENBQUEsR0FBSSxDQUFBLENBQUEsQ0FBSixDQUFMLEdBQWUsR0FBSSxDQUFBLENBQUEsRUFBM0M7O0lBREY7V0FFQTtFQUpjOzs7QUFPaEI7Ozs7Ozs7OztFQVFBLGNBQUEsR0FBaUIsU0FBQyxDQUFEO0FBQ2YsUUFBQTtJQUFBLENBQUEsR0FBSSxDQUFDLENBQUMsS0FBRixDQUFRLEdBQVI7SUFDSixHQUFBLEdBQU0sVUFBVSxDQUFDLEdBQVgsQ0FBZSxDQUFFLENBQUEsQ0FBQSxDQUFqQjtJQUVOLElBQUcsQ0FBSSxHQUFQO0FBQWdCLFlBQVUsSUFBQSxrQkFBQSxDQUFtQixjQUFBLEdBQWUsQ0FBRSxDQUFBLENBQUEsQ0FBakIsR0FBb0IseUNBQXZDLEVBQTFCOztJQUlBLElBQUcsQ0FBRSxDQUFBLENBQUEsQ0FBTDtNQUVFLElBQUEsR0FBTyxDQUFFLENBQUEsQ0FBQSxDQUFFLENBQUMsS0FBTCxDQUFXLEdBQVgsQ0FBZSxDQUFDLEdBQWhCLENBQW9CLFNBQUMsQ0FBRDtlQUFPLENBQUMsQ0FBQyxJQUFGLENBQUE7TUFBUCxDQUFwQixFQUZUO0tBQUEsTUFBQTtNQUlFLElBQUEsR0FBTyxHQUpUOztXQU1BLElBQUksQ0FBQyxRQUFRLENBQUMsU0FBUyxDQUFDLElBQUksQ0FBQyxLQUF4QixDQUE4QixHQUE5QixFQUFtQyxDQUFDLElBQUQsQ0FBTSxDQUFDLE1BQVAsQ0FBYyxJQUFkLENBQW5DLENBQUQ7RUFkVzs7O0FBaUJqQjs7Ozs7OztFQU1BLE1BQU0sQ0FBQyxPQUFPLENBQUMsS0FBZixHQUF1QixTQUFDLENBQUQ7QUFHckIsUUFBQTtJQUFBLEVBQUEsR0FBSyxDQUFDLENBQUMsS0FBRixDQUFRLEdBQVI7SUFDTCxJQUFBLEdBQU87QUFHUCxTQUFBLG9DQUFBOztNQUNFLENBQUEsR0FBSSxDQUFDLENBQUMsSUFBRixDQUFBO01BQ0osSUFBRyxDQUFDLENBQUMsTUFBRixLQUFZLENBQWY7QUFBc0IsaUJBQXRCOztNQUNBLEdBQUEsR0FBTSxjQUFBLENBQWUsQ0FBZjtNQUNOLEtBQUEsQ0FBTSxHQUFHLENBQUMsUUFBVixFQUFvQixhQUFBLENBQWMsQ0FBZCxDQUFwQjtNQUNBLElBQUksQ0FBQyxJQUFMLENBQVUsR0FBVjtBQUxGO1dBT0E7RUFkcUI7OztBQWlCdkI7Ozs7Ozs7RUFNQSxNQUFNLENBQUMsT0FBTyxDQUFDLFVBQWYsR0FBNEI7QUFwRzVCIiwiZmlsZSI6InZhbGlkYXRvcnMvcGFyc2VyLmpzIiwic291cmNlUm9vdCI6Ii9zb3VyY2UvIiwic291cmNlc0NvbnRlbnQiOlsiIyMjKlxuI1xuI1xuI1xuI1xuIyMjXG5JbGxlZ2FsQXJndW1lbnRFcnIgID0gcmVxdWlyZSgnc3RvdXQtY29yZS9lcnInKS5JbGxlZ2FsQXJndW1lbnRFcnJcbkhhc1ZhbGlkYXRpb25TdGF0ZXMgPSByZXF1aXJlICdzdG91dC1jb3JlL3RyYWl0cy9IYXNWYWxpZGF0aW9uU3RhdGVzJ1xua2V5cyAgICAgICAgICAgICAgICA9IHJlcXVpcmUgJ2xvZGFzaC9rZXlzJ1xuTWFwICAgICAgICAgICAgICAgICA9IHJlcXVpcmUgJ3N0b3V0LWNvcmUvY29sbGVjdGlvbi9NYXAnXG5tZXJnZSAgICAgICAgICAgICAgID0gcmVxdWlyZSAnbG9kYXNoL21lcmdlJ1xuXG5cbkJVSUxUX0lOX1ZBTElEQVRPUlMgPVxuICAnbWF4JzogICAgICByZXF1aXJlICdzdG91dC1jb3JlL3ZhbGlkYXRvcnMvTWF4J1xuICAnbWluJzogICAgICByZXF1aXJlICdzdG91dC1jb3JlL3ZhbGlkYXRvcnMvTWluJ1xuICAnc2l6ZSc6ICAgICByZXF1aXJlICdzdG91dC1jb3JlL3ZhbGlkYXRvcnMvU2l6ZSdcbiAgJ3JlcXVpcmVkJzogcmVxdWlyZSAnc3RvdXQtY29yZS92YWxpZGF0b3JzL1JlcXVpcmVkJ1xuXG5cbnZhbGlkYXRvcnMgPSBuZXcgTWFwKClcblxuZm9yIGssIHYgb2YgQlVJTFRfSU5fVkFMSURBVE9SU1xuICB2YWxpZGF0b3JzLnB1dCBrLCB2XG5cbiMgR2VuZXJhdGUgdGhlIG1lc3NhZ2VzIHJlZ3VsYXIgZXhwcmVzc2lvbi5cbnN0YXRlcyA9IGtleXMoSGFzVmFsaWRhdGlvblN0YXRlcy5TVEFURVMpLmpvaW4gJ3wnXG5tc2dzUmVnRXhwID0gbmV3IFJlZ0V4cCBcIigje3N0YXRlc30pXFxcXFsoW15cXFxcXV0rKVxcXFxdXCIsICdnJ1xuXG4jIyMqXG4jIFBhcnNlcy1vdXQgbWVzc2FnZXMgZnJvbSB2YWxpZGF0b3IgZGVzY3JpcHRvci5cbiNcbiMgQHBhcmFtIHtzdHJpbmd9IC0gVmFsaWRhdG9yIGRlc2NyaXB0b3IuXG4jXG4jIEByZXR1cm5zIHtPYmplY3R9IE1lc3NhZ2VzIG9iamVjdCBrZXllZCBieSB2YWxpZGF0b3Igc3RhdGUuXG4jXG4jIEBmdW5jdGlvbiBwYXJzZU1lc3NhZ2VzXG4jIEBpbm5lclxuIyMjXG5wYXJzZU1lc3NhZ2VzID0gKHYpIC0+XG4gIG1zZ3MgPSB7fVxuICB3aGlsZSAocmVzID0gbXNnc1JlZ0V4cC5leGVjIHYpIGlzbnQgbnVsbFxuICAgIGlmIHJlcy5sZW5ndGggPj0gMyB0aGVuIG1zZ3NbcmVzWzFdXSA9IHJlc1syXVxuICBtc2dzXG5cblxuIyMjKlxuIyBQYXJzZXMgYW5kIGluc3RhbnRpYXRlcyB0aGUgdmFsaWRhdG9yLlxuI1xuIyBAcGFyYW0ge3N0cmluZ30gLSBWYWxpZGF0b3IgZGVzY3JpcHRvci5cbiNcbiMgQFxuI1xuIyMjXG5wYXJzZVZhbGlkYXRvciA9ICh2KSAtPlxuICB2ID0gdi5zcGxpdCAnOidcbiAgY2xzID0gdmFsaWRhdG9ycy5nZXQgdlswXVxuXG4gIGlmIG5vdCBjbHMgdGhlbiB0aHJvdyBuZXcgSWxsZWdhbEFyZ3VtZW50RXJyIFwiVmFsaWRhdG9yIFxcXCIje3ZbMF19XFxcIiBkb2VzIG5vdFxuICBleGlzdCBvciBpcyBub3QgcmVnaXN0ZXJlZC5cIlxuXG4gICMgSWYgYXJndW1lbnRzIHdlcmUgc3BlY2lmaWVkLlxuICBpZiB2WzFdXG4gICAgIyBSZW1vdmUgZXh0cmEgd2hpdGVzcGFjZSBhbmQgY29udmVydCB0byBhcnJheS5cbiAgICBhcmdzID0gdlsxXS5zcGxpdCgnLCcpLm1hcCAocykgLT4gcy50cmltKClcbiAgZWxzZVxuICAgIGFyZ3MgPSBbXVxuXG4gIG5ldyAoRnVuY3Rpb24ucHJvdG90eXBlLmJpbmQuYXBwbHkgY2xzLCBbbnVsbF0uY29uY2F0IGFyZ3MpXG5cblxuIyMjKlxuIyBQYXJzZXMgYSB2YWxpZGF0b3Igc3RyaW5nIGFuZCBpbnN0YW50aWF0ZXMgdGhlIGFwcHJvcHJpYXRlIFZhbGlkYXRvciBjbGFzc2VzLlxuI1xuIyBAZXhwb3J0cyBzdG91dC11aS92YWxpZGF0b3JzL3BhcnNlclxuIyBAZnVuY3Rpb24gcGFyc2VyXG4jIyNcbm1vZHVsZS5leHBvcnRzLnBhcnNlID0gKHMpIC0+XG5cbiAgIyBTcGxpdCB2YWxpZGF0b3JzIG9uIGRlbGltaXRlciBjaGFyYWN0ZXIuXG4gIHZzID0gcy5zcGxpdCAnfCdcbiAgdmFscyA9IFtdXG5cbiAgIyBQYXJzZSBlYWNoIHZhbGlkYXRvciBkZXNjcmlwdG9yLlxuICBmb3IgdiBpbiB2c1xuICAgIHYgPSB2LnRyaW0oKVxuICAgIGlmIHYubGVuZ3RoIGlzIDAgdGhlbiBjb250aW51ZVxuICAgIHZhbCA9IHBhcnNlVmFsaWRhdG9yIHZcbiAgICBtZXJnZSB2YWwubWVzc2FnZXMsIHBhcnNlTWVzc2FnZXMgdlxuICAgIHZhbHMucHVzaCB2YWxcblxuICB2YWxzXG5cblxuIyMjKlxuIyBUaGUgdmFsaWRhdG9ycyBtYXAgd2hpY2ggY2FuIGJlIGFkZGVkLXRvIGZvciBleHRlbmRpbmcgdGhlIHBhcnNlcidzIHZvY2FidWxhcnlcbiMgb2YgdmFsaWRhdG9ycy5cbiNcbiMgQGV4cG9ydHMgc3RvdXQtdWkvdmFsaWRhdG9ycy9wYXJzZXIudmFsaWRhdG9yc1xuIyMjXG5tb2R1bGUuZXhwb3J0cy52YWxpZGF0b3JzID0gdmFsaWRhdG9yc1xuIl19
