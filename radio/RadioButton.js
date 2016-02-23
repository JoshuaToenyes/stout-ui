
/**
 * @overview Defines the RadioButton class, a standard radio button which is
 * capable of being grouped by a group ID.
 *
 * @module stout-ui/radio/RadioButton
 */

(function() {
  var Container, FILL_BOUNDS_CLS, FILL_CLS, INDICATOR_CLS, LABEL_CLS, RADIO_CLS, RadioButton, fill, ink, template, use, vars,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  Container = require('../container/Container');

  vars = require('../vars');

  template = require('./radio-button.template');

  use = require('stout-core/trait/use');

  fill = require('../traits/fill');

  ink = require('../traits/ink');

  require('../vars/radio');


  /**
   * The radio button class applied to the root component.
   * @type string
   * @const
   * @private
   */

  RADIO_CLS = vars.read('radio/radio-class');


  /**
   * The classname of the element which will act as the displayed radio button,
   * or the "indicator."
   * @type string
   * @const
   * @private
   */

  INDICATOR_CLS = vars.readPrefixed('radio/radio-indicator-class');


  /**
   * The class name of the radio button label, applied if using the radio buttons
   * `label` property.
   * @type string
   * @const
   * @private
   */

  LABEL_CLS = vars.readPrefixed('radio/radio-label-class');


  /**
   * The container classname which will hold the ink fill inside the radio button.
   * @type string
   * @const
   * @private
   */

  FILL_CLS = vars.readPrefixed('fill/fill-container-class');


  /**
   *
   * @type string
   * @const
   * @private
   */

  FILL_BOUNDS_CLS = vars.readPrefixed('radio/radio-fill-bounds');

  module.exports = RadioButton = (function(superClass) {
    extend(RadioButton, superClass);


    /**
     * The RadioButton class represents a single radio button which may be linked
     * to other RadioButton instances to ensure mutual exlusivity.
     *
     * @param {Object} [init] - Initiation object.
     *
     * @exports stout-ui/radio/RadioButton
     * @extends stout-ui/container/Container
     * @constructor
     */

    function RadioButton(init) {
      RadioButton.__super__.constructor.call(this, template, null, {
        renderOnChange: false
      }, init, ['select', 'unselect']);
      this.prefixedClasses.add(RADIO_CLS);
      use(ink)(this);
      use(fill)(this);
    }


    /**
     * The radio button indicator's class name. A member primarily for the
     * template.
     * @member indicatorClassName
     * @memberof stout-ui/radio/RadioButton
     * @type string
     * @const
     * @private
     */

    RadioButton.property('indicatorClassName', {
      "const": true,
      value: INDICATOR_CLS
    });


    /**
     * The class name of the radio button label, if using the "label" property.
     * @member labelClassName
     * @memberof stout-ui/radio/RadioButton
     * @type string
     * @const
     * @private
     */

    RadioButton.property('labelClassName', {
      "const": true,
      value: LABEL_CLS
    });


    /**
     * The ID of the group this radio button belongs to.
     * @member group
     * @memberof stout-ui/radio/RadioButton
     * @type string|number
     */

    RadioButton.property('group');


    /**
     * The label for this radio button.
     * @member label
     * @memberof stout-ui/radio/RadioButton
     * @type string
     */

    RadioButton.property('label', {
      "default": '',
      set: function(l) {
        return this.contents = "<span class=" + this.labelClassName + ">" + l + "</span>";
      }
    });

    RadioButton.property('fillClassName', {
      "const": true,
      value: FILL_CLS
    });

    RadioButton.property('fillBoundsClassName', {
      "const": true,
      value: FILL_BOUNDS_CLS
    });

    RadioButton.prototype.render = function() {
      RadioButton.__super__.render.call(this);
      return this.fill();
    };

    return RadioButton;

  })(Container);

}).call(this);

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbInJhZGlvL1JhZGlvQnV0dG9uLmNvZmZlZSJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiO0FBQUE7Ozs7Ozs7QUFBQTtBQUFBLE1BQUEsc0hBQUE7SUFBQTs7O0VBT0EsU0FBQSxHQUFZLE9BQUEsQ0FBUSx3QkFBUjs7RUFDWixJQUFBLEdBQVksT0FBQSxDQUFRLFNBQVI7O0VBQ1osUUFBQSxHQUFZLE9BQUEsQ0FBUSx5QkFBUjs7RUFDWixHQUFBLEdBQWMsT0FBQSxDQUFRLHNCQUFSOztFQUNkLElBQUEsR0FBWSxPQUFBLENBQVEsZ0JBQVI7O0VBQ1osR0FBQSxHQUFjLE9BQUEsQ0FBUSxlQUFSOztFQUlkLE9BQUEsQ0FBUSxlQUFSOzs7QUFHQTs7Ozs7OztFQU1BLFNBQUEsR0FBWSxJQUFJLENBQUMsSUFBTCxDQUFVLG1CQUFWOzs7QUFHWjs7Ozs7Ozs7RUFPQSxhQUFBLEdBQWdCLElBQUksQ0FBQyxZQUFMLENBQWtCLDZCQUFsQjs7O0FBR2hCOzs7Ozs7OztFQU9BLFNBQUEsR0FBWSxJQUFJLENBQUMsWUFBTCxDQUFrQix5QkFBbEI7OztBQUdaOzs7Ozs7O0VBTUEsUUFBQSxHQUFXLElBQUksQ0FBQyxZQUFMLENBQWtCLDJCQUFsQjs7O0FBR1g7Ozs7Ozs7RUFNQSxlQUFBLEdBQWtCLElBQUksQ0FBQyxZQUFMLENBQWtCLHlCQUFsQjs7RUFHbEIsTUFBTSxDQUFDLE9BQVAsR0FBdUI7Ozs7QUFFckI7Ozs7Ozs7Ozs7O0lBVWEscUJBQUMsSUFBRDtNQUNYLDZDQUFNLFFBQU4sRUFBZ0IsSUFBaEIsRUFBc0I7UUFBQyxjQUFBLEVBQWdCLEtBQWpCO09BQXRCLEVBQStDLElBQS9DLEVBQXFELENBQUMsUUFBRCxFQUFXLFVBQVgsQ0FBckQ7TUFDQSxJQUFDLENBQUEsZUFBZSxDQUFDLEdBQWpCLENBQXFCLFNBQXJCO01BQ0EsR0FBQSxDQUFJLEdBQUosQ0FBQSxDQUFTLElBQVQ7TUFDQSxHQUFBLENBQUksSUFBSixDQUFBLENBQVUsSUFBVjtJQUpXOzs7QUFNYjs7Ozs7Ozs7OztJQVNBLFdBQUMsQ0FBQSxRQUFELENBQVUsb0JBQVYsRUFDRTtNQUFBLE9BQUEsRUFBTyxJQUFQO01BQ0EsS0FBQSxFQUFPLGFBRFA7S0FERjs7O0FBS0E7Ozs7Ozs7OztJQVFBLFdBQUMsQ0FBQSxRQUFELENBQVUsZ0JBQVYsRUFDRTtNQUFBLE9BQUEsRUFBTyxJQUFQO01BQ0EsS0FBQSxFQUFPLFNBRFA7S0FERjs7O0FBS0E7Ozs7Ozs7SUFNQSxXQUFDLENBQUEsUUFBRCxDQUFVLE9BQVY7OztBQUdBOzs7Ozs7O0lBTUEsV0FBQyxDQUFBLFFBQUQsQ0FBVSxPQUFWLEVBQ0U7TUFBQSxTQUFBLEVBQVMsRUFBVDtNQUNBLEdBQUEsRUFBSyxTQUFDLENBQUQ7ZUFDSCxJQUFDLENBQUEsUUFBRCxHQUFZLGNBQUEsR0FBZSxJQUFDLENBQUEsY0FBaEIsR0FBK0IsR0FBL0IsR0FBa0MsQ0FBbEMsR0FBb0M7TUFEN0MsQ0FETDtLQURGOztJQU1BLFdBQUMsQ0FBQSxRQUFELENBQVUsZUFBVixFQUNFO01BQUEsT0FBQSxFQUFPLElBQVA7TUFDQSxLQUFBLEVBQU8sUUFEUDtLQURGOztJQUtBLFdBQUMsQ0FBQSxRQUFELENBQVUscUJBQVYsRUFDRTtNQUFBLE9BQUEsRUFBTyxJQUFQO01BQ0EsS0FBQSxFQUFPLGVBRFA7S0FERjs7MEJBSUEsTUFBQSxHQUFRLFNBQUE7TUFDTixzQ0FBQTthQUNBLElBQUMsQ0FBQSxJQUFELENBQUE7SUFGTTs7OztLQTNFaUM7QUFsRTNDIiwiZmlsZSI6InJhZGlvL1JhZGlvQnV0dG9uLmpzIiwic291cmNlUm9vdCI6Ii9zb3VyY2UvIiwic291cmNlc0NvbnRlbnQiOlsiIyMjKlxuIyBAb3ZlcnZpZXcgRGVmaW5lcyB0aGUgUmFkaW9CdXR0b24gY2xhc3MsIGEgc3RhbmRhcmQgcmFkaW8gYnV0dG9uIHdoaWNoIGlzXG4jIGNhcGFibGUgb2YgYmVpbmcgZ3JvdXBlZCBieSBhIGdyb3VwIElELlxuI1xuIyBAbW9kdWxlIHN0b3V0LXVpL3JhZGlvL1JhZGlvQnV0dG9uXG4jIyNcblxuQ29udGFpbmVyID0gcmVxdWlyZSAnLi4vY29udGFpbmVyL0NvbnRhaW5lcidcbnZhcnMgICAgICA9IHJlcXVpcmUgJy4uL3ZhcnMnXG50ZW1wbGF0ZSAgPSByZXF1aXJlICcuL3JhZGlvLWJ1dHRvbi50ZW1wbGF0ZSdcbnVzZSAgICAgICAgID0gcmVxdWlyZSAnc3RvdXQtY29yZS90cmFpdC91c2UnXG5maWxsICAgICAgPSByZXF1aXJlICcuLi90cmFpdHMvZmlsbCdcbmluayAgICAgICAgID0gcmVxdWlyZSAnLi4vdHJhaXRzL2luaydcblxuXG4jIFJlcXVpcmUgbmVjZXNzYXJ5IHNoYXJlZCB2YXJpYWJsZXMuXG5yZXF1aXJlICcuLi92YXJzL3JhZGlvJ1xuXG5cbiMjIypcbiMgVGhlIHJhZGlvIGJ1dHRvbiBjbGFzcyBhcHBsaWVkIHRvIHRoZSByb290IGNvbXBvbmVudC5cbiMgQHR5cGUgc3RyaW5nXG4jIEBjb25zdFxuIyBAcHJpdmF0ZVxuIyMjXG5SQURJT19DTFMgPSB2YXJzLnJlYWQgJ3JhZGlvL3JhZGlvLWNsYXNzJ1xuXG5cbiMjIypcbiMgVGhlIGNsYXNzbmFtZSBvZiB0aGUgZWxlbWVudCB3aGljaCB3aWxsIGFjdCBhcyB0aGUgZGlzcGxheWVkIHJhZGlvIGJ1dHRvbixcbiMgb3IgdGhlIFwiaW5kaWNhdG9yLlwiXG4jIEB0eXBlIHN0cmluZ1xuIyBAY29uc3RcbiMgQHByaXZhdGVcbiMjI1xuSU5ESUNBVE9SX0NMUyA9IHZhcnMucmVhZFByZWZpeGVkICdyYWRpby9yYWRpby1pbmRpY2F0b3ItY2xhc3MnXG5cblxuIyMjKlxuIyBUaGUgY2xhc3MgbmFtZSBvZiB0aGUgcmFkaW8gYnV0dG9uIGxhYmVsLCBhcHBsaWVkIGlmIHVzaW5nIHRoZSByYWRpbyBidXR0b25zXG4jIGBsYWJlbGAgcHJvcGVydHkuXG4jIEB0eXBlIHN0cmluZ1xuIyBAY29uc3RcbiMgQHByaXZhdGVcbiMjI1xuTEFCRUxfQ0xTID0gdmFycy5yZWFkUHJlZml4ZWQgJ3JhZGlvL3JhZGlvLWxhYmVsLWNsYXNzJ1xuXG5cbiMjIypcbiMgVGhlIGNvbnRhaW5lciBjbGFzc25hbWUgd2hpY2ggd2lsbCBob2xkIHRoZSBpbmsgZmlsbCBpbnNpZGUgdGhlIHJhZGlvIGJ1dHRvbi5cbiMgQHR5cGUgc3RyaW5nXG4jIEBjb25zdFxuIyBAcHJpdmF0ZVxuIyMjXG5GSUxMX0NMUyA9IHZhcnMucmVhZFByZWZpeGVkICdmaWxsL2ZpbGwtY29udGFpbmVyLWNsYXNzJ1xuXG5cbiMjIypcbiNcbiMgQHR5cGUgc3RyaW5nXG4jIEBjb25zdFxuIyBAcHJpdmF0ZVxuIyMjXG5GSUxMX0JPVU5EU19DTFMgPSB2YXJzLnJlYWRQcmVmaXhlZCAncmFkaW8vcmFkaW8tZmlsbC1ib3VuZHMnXG5cblxubW9kdWxlLmV4cG9ydHMgPSBjbGFzcyBSYWRpb0J1dHRvbiBleHRlbmRzIENvbnRhaW5lclxuXG4gICMjIypcbiAgIyBUaGUgUmFkaW9CdXR0b24gY2xhc3MgcmVwcmVzZW50cyBhIHNpbmdsZSByYWRpbyBidXR0b24gd2hpY2ggbWF5IGJlIGxpbmtlZFxuICAjIHRvIG90aGVyIFJhZGlvQnV0dG9uIGluc3RhbmNlcyB0byBlbnN1cmUgbXV0dWFsIGV4bHVzaXZpdHkuXG4gICNcbiAgIyBAcGFyYW0ge09iamVjdH0gW2luaXRdIC0gSW5pdGlhdGlvbiBvYmplY3QuXG4gICNcbiAgIyBAZXhwb3J0cyBzdG91dC11aS9yYWRpby9SYWRpb0J1dHRvblxuICAjIEBleHRlbmRzIHN0b3V0LXVpL2NvbnRhaW5lci9Db250YWluZXJcbiAgIyBAY29uc3RydWN0b3JcbiAgIyMjXG4gIGNvbnN0cnVjdG9yOiAoaW5pdCkgLT5cbiAgICBzdXBlciB0ZW1wbGF0ZSwgbnVsbCwge3JlbmRlck9uQ2hhbmdlOiBmYWxzZX0sIGluaXQsIFsnc2VsZWN0JywgJ3Vuc2VsZWN0J11cbiAgICBAcHJlZml4ZWRDbGFzc2VzLmFkZCBSQURJT19DTFNcbiAgICB1c2UoaW5rKSBAXG4gICAgdXNlKGZpbGwpIEBcblxuICAjIyMqXG4gICMgVGhlIHJhZGlvIGJ1dHRvbiBpbmRpY2F0b3IncyBjbGFzcyBuYW1lLiBBIG1lbWJlciBwcmltYXJpbHkgZm9yIHRoZVxuICAjIHRlbXBsYXRlLlxuICAjIEBtZW1iZXIgaW5kaWNhdG9yQ2xhc3NOYW1lXG4gICMgQG1lbWJlcm9mIHN0b3V0LXVpL3JhZGlvL1JhZGlvQnV0dG9uXG4gICMgQHR5cGUgc3RyaW5nXG4gICMgQGNvbnN0XG4gICMgQHByaXZhdGVcbiAgIyMjXG4gIEBwcm9wZXJ0eSAnaW5kaWNhdG9yQ2xhc3NOYW1lJyxcbiAgICBjb25zdDogdHJ1ZVxuICAgIHZhbHVlOiBJTkRJQ0FUT1JfQ0xTXG5cblxuICAjIyMqXG4gICMgVGhlIGNsYXNzIG5hbWUgb2YgdGhlIHJhZGlvIGJ1dHRvbiBsYWJlbCwgaWYgdXNpbmcgdGhlIFwibGFiZWxcIiBwcm9wZXJ0eS5cbiAgIyBAbWVtYmVyIGxhYmVsQ2xhc3NOYW1lXG4gICMgQG1lbWJlcm9mIHN0b3V0LXVpL3JhZGlvL1JhZGlvQnV0dG9uXG4gICMgQHR5cGUgc3RyaW5nXG4gICMgQGNvbnN0XG4gICMgQHByaXZhdGVcbiAgIyMjXG4gIEBwcm9wZXJ0eSAnbGFiZWxDbGFzc05hbWUnLFxuICAgIGNvbnN0OiB0cnVlXG4gICAgdmFsdWU6IExBQkVMX0NMU1xuXG5cbiAgIyMjKlxuICAjIFRoZSBJRCBvZiB0aGUgZ3JvdXAgdGhpcyByYWRpbyBidXR0b24gYmVsb25ncyB0by5cbiAgIyBAbWVtYmVyIGdyb3VwXG4gICMgQG1lbWJlcm9mIHN0b3V0LXVpL3JhZGlvL1JhZGlvQnV0dG9uXG4gICMgQHR5cGUgc3RyaW5nfG51bWJlclxuICAjIyNcbiAgQHByb3BlcnR5ICdncm91cCdcblxuXG4gICMjIypcbiAgIyBUaGUgbGFiZWwgZm9yIHRoaXMgcmFkaW8gYnV0dG9uLlxuICAjIEBtZW1iZXIgbGFiZWxcbiAgIyBAbWVtYmVyb2Ygc3RvdXQtdWkvcmFkaW8vUmFkaW9CdXR0b25cbiAgIyBAdHlwZSBzdHJpbmdcbiAgIyMjXG4gIEBwcm9wZXJ0eSAnbGFiZWwnLFxuICAgIGRlZmF1bHQ6ICcnXG4gICAgc2V0OiAobCkgLT5cbiAgICAgIEBjb250ZW50cyA9IFwiPHNwYW4gY2xhc3M9I3tAbGFiZWxDbGFzc05hbWV9PiN7bH08L3NwYW4+XCJcblxuXG4gIEBwcm9wZXJ0eSAnZmlsbENsYXNzTmFtZScsXG4gICAgY29uc3Q6IHRydWVcbiAgICB2YWx1ZTogRklMTF9DTFNcblxuXG4gIEBwcm9wZXJ0eSAnZmlsbEJvdW5kc0NsYXNzTmFtZScsXG4gICAgY29uc3Q6IHRydWVcbiAgICB2YWx1ZTogRklMTF9CT1VORFNfQ0xTXG5cbiAgcmVuZGVyOiAtPlxuICAgIHN1cGVyKClcbiAgICBAZmlsbCgpXG4iXX0=
