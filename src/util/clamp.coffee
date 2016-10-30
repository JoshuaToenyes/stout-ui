###*
# Clamps the passed value `v` to within `min` and `max` values.
#
# @param {number} v - The value to clamp.
#
# @param {number} min - The minimum value.
#
# @param {number} max - The maximum value.
#
# @returns {number} A number between `min` and `max`.
#
# @exports stout-ui/util/clamp
# @function clamp
###
module.exports = (v, min, max) -> Math.max(min, Math.min(max, v))
