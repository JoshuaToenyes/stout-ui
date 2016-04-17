(function() {
  var HintValidator, Validator,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  Validator = require('stout-core/validation/Validator');

  module.exports = HintValidator = (function(superClass) {
    extend(HintValidator, superClass);

    function HintValidator(msg) {
      HintValidator.__super__.constructor.call(this);
      this.validation = 'hint';
      this.message = msg;
    }

    return HintValidator;

  })(Validator);

}).call(this);

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbInZhbGlkYXRvcnMvSGludFZhbGlkYXRvci5jb2ZmZWUiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IkFBQUE7QUFBQSxNQUFBLHdCQUFBO0lBQUE7OztFQUFBLFNBQUEsR0FBWSxPQUFBLENBQVEsaUNBQVI7O0VBRVosTUFBTSxDQUFDLE9BQVAsR0FBdUI7OztJQUVSLHVCQUFDLEdBQUQ7TUFDWCw2Q0FBQTtNQUNBLElBQUMsQ0FBQSxVQUFELEdBQWM7TUFDZCxJQUFDLENBQUEsT0FBRCxHQUFXO0lBSEE7Ozs7S0FGOEI7QUFGN0MiLCJmaWxlIjoidmFsaWRhdG9ycy9IaW50VmFsaWRhdG9yLmpzIiwic291cmNlUm9vdCI6Ii9zb3VyY2UvIiwic291cmNlc0NvbnRlbnQiOlsiVmFsaWRhdG9yID0gcmVxdWlyZSAnc3RvdXQtY29yZS92YWxpZGF0aW9uL1ZhbGlkYXRvcidcblxubW9kdWxlLmV4cG9ydHMgPSBjbGFzcyBIaW50VmFsaWRhdG9yIGV4dGVuZHMgVmFsaWRhdG9yXG5cbiAgY29uc3RydWN0b3I6IChtc2cpIC0+XG4gICAgc3VwZXIoKVxuICAgIEB2YWxpZGF0aW9uID0gJ2hpbnQnXG4gICAgQG1lc3NhZ2UgPSBtc2dcbiJdfQ==
