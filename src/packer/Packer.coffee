###*
#
#
#
###
assign  = require 'lodash/assign'
memoize = require 'lodash/memoize'
reverse = require 'lodash/reverse'
uniq    = require 'lodash/uniq'


module.exports = class Packer

  ###*
  # Initiates a packer and returns a packer struct. The maximum width of a
  # packer is 32. In other words, it will only support packing items into a
  # maximum of 32 bins.
  #
  # @param {int} height - The maximum number of rows, or the height of the
  # packing grid.
  #
  # @param {int} width - The number of columns, with a maximum value of 32.
  #
  # @returns {stout-ui/util/packer/PackerStruct} Packer struct.
  #
  # @function init
  ###
  constructor: (height, width) ->
    if width > 32
      throw new Error 'Packer supports a maximum of 32 columns.'
    @m = new Uint32Array(height)
    @w = width
    @i = {}


  ###*
  # Inserts an item with a string `id` into the packer.
  #
  # @param {stout-ui/util/packer/PackerStruct} p - The packer.
  #
  # @param {int} height - The height (in rows) of the item to insert.
  #
  # @param {int} width - The width (in columns) of the item to insert.
  #
  # @param {string} The `id` of the item to insert.
  #
  # @returns {Array.<int, int>} Returns an array of form `[row, col]` with the
  # row and column at-which the item was inserted.
  ###
  insert: (height, width, id) ->
    [row, col] = @_fit(height, width)
    @insertAt height, width, row, col, id
    [row, col]


  insertWithin: (itemRow, itemCol, height, width, startRow, endRow, startCol, endCol, id, shifted = {}) ->

    prow = startRow + height #width
    pcol = startCol + width #height


    startRow = Math.max(0, startRow)
    endRow = Math.min(endRow, @m.length)
    startCol = Math.max(0, startCol)
    endCol = Math.min(endCol, @w)


    [row, col] = @_fit(height, width, startRow, endRow, startCol, endCol)

    if row is undefined
      q = 0

      while q < height
        assign(shifted, @shiftDownNeighborsBelow height, width, prow + q, itemCol)
        q++

      [row, col] = @_fit(height, width, startRow, endRow, startCol, endCol)
      shifted[id] = @insertAt(height, width, row, col, id)
      return shifted

      #[row, col] = packer._fit(p, height, width, startRow, endRow, startCol, endCol)
      #assign(shifted, packer.insertWithin.apply(@, arguments))
    else
      shifted[id] = @insertAt(height, width, row, col, id)
      shifted


  ###*
  # Inserts item with `id` of size `height` by `width` at `row` and `col`.
  #
  # @param {stout-ui/util/packer/PackerStruct} p - The packer.
  #
  # @param {int} height - The height (in rows) of the item to insert.
  #
  # @param {int} width - The width (in columns) of the item to insert.
  #
  # @param {int} row - The row at-which to insert.
  #
  # @param {int} col - The column at-which to insert.
  #
  # @param {string} The `id` of the item to insert.
  #
  # @returns {object} An object which describes the position and size of the
  # inserted item in the form, `{height, width, row, col}`.
  ###
  insertAt: (height, width, row, col, id) ->
    @_fill(height, width, row, col)
    @i[id] = {height, width, row, col}


  ###*
  # Removes an item from the packer by it's `id`.
  #
  # @param {stout-ui/util/packer/PackerStruct} p - The packer.
  #
  # @param {string} The `id` of the item to insert.
  #
  # @returns {object} An object in the form `{height, width, row, col}` of where
  # the item resided in the packer before it was removed, or `false` if an item
  # with the specified `id` does not exist.
  ###
  remove: (id) ->
    item = @i[id]
    if not item then return false
    @_unfill item.height, item.width, item.row, item.col
    @i[id] = null
    item


  ###*
  # Returns the current height (in rows) of the passed packer.
  #
  # @param {stout-ui/util/packer/PackerStruct} p - The packer.
  #
  # @returns {int} The packer's current height.
  ###
  height: ->
    h = -1
    row = 0
    while row < @m.length
      if @m[row] and row > h then h = row
      row++
    return h + 1


  ###*
  # Returns the current width (in columns) of the passed packer.
  #
  # @param {stout-ui/util/packer/PackerStruct} p - The packer.
  #
  # @returns {int} The packer's current width.
  ###
  width: ->
    w = -1
    row = 0
    while row < @m.length
      col = 0
      while col < @w
        if @_isset(row, col) and col > w then w = col
        col++
      row++
    return w + 1


  ###*
  # Returns the string `id` of the item in packer `p` at `row` and `col`.
  #
  # @param {stout-ui/util/packer/PackerStruct} p - The packer.
  #
  # @param {int} pRow - The row.
  #
  # @param {int} pCol - The column.
  #
  # @returns {string} The string `id` of the item at the specified `row` and
  # `col`, or `false` if not filled.
  ###
  at: (pRow, pCol) ->
    for id, item of @i
      if not item then continue
      {height, width, row, col} = item
      if (col <= pCol) and (col + width > pCol) and
      (row <= pRow) and (row + height  > pRow)
        return id


  ###*
  # Constrains the passed `row` and `col` to the size of the grid for the item
  # specified by `id`.
  #
  #
  ###
  constrain: (id, row, col) ->
    item = @i[id]
    row = Math.min(@m.length - item.height, Math.max(0, row))
    col = Math.min(@w - item.width, Math.max(0, col))
    [row, col]


  ###*
  #
  #
  #
  ###
  moveTo: (id, row, col, height, width) ->
    shifted = {}

    [row, col] = @constrain id, row, col

    item = @remove id

    if height then item.height = height

    if width then item.width = width

    overlappingItemIds = @itemsWithin(item.height, item.width, row, col)

    oItems = {}
    for oItemId in overlappingItemIds
      oItem = @remove oItemId
      oItems[oItemId] = oItem

    shifted[id] = @insertAt item.height, item.width, row, col, id

    for oItemId, oItem of oItems
      startRow = row - oItem.height
      endRow = row + item.height + oItem.height
      startCol = col - oItem.width
      endCol = col + item.width + oItem.width

      assign(shifted, @insertWithin oItem.row, oItem.col, oItem.height, oItem.width, startRow, endRow, startCol, endCol, oItemId, shifted)

    shifted


  ###*
  # Finds the furthest right column filled by items with the passed `ids`.
  #
  #
  ###
  maxCol: (ids) ->
    max = 0
    for id in ids
      item = @i[id]
      m = item.col + item.width
      if m > max then max = m
    max


  ###*
  # Finds the furthest left column filled by items with the passed `ids`.
  #
  #
  ###
  minCol: (ids) ->
    min = @w
    for id in ids
      item = @i[id]
      if item.col < max then min = item.col
    min


  ###*
  # Shifts-down the neighbors below the specified area.
  #
  #
  ###
  shiftDownNeighborsBelow: (height, width, row, col) ->
    shifted = {}

    belowIds = reverse(@_itemsBelow(height, width, row, col))
    for belowId in belowIds
      shifted[belowId] = @_shiftDown belowId

    shifted


  ###*
  # Shifts the passed item down.
  #
  # @param {string} id - The `id` of the item to shift down.
  #
  # @returns {object} An object which describes the new position and size of the
  # shifted item in the form, `{height, width, row, col}`.
  ###
  _shiftDown: (id) ->
    item = @remove id
    @insertAt item.height, item.width, item.row + 1, item.col, id


  ###*
  # Shifts elements back-up to fill-in where they were previously shifted down.
  #
  # @param {Array.<string>} ids - Array of string ID's of elements to shift back
  # up, in a top-to-bottom order.
  ###
  shiftUpToFill: (ids) ->
    shifted = {}
    for id in ids
      item = @remove id
      row = item.row
      while @_fits(item.height, item.width, row - 1, item.col) and row - 1 >= 0
        row--
      shifted[id] = @insertAt item.height, item.width, row, item.col, id
    shifted


  ###*
  # Returns a set of `id`'s of items within a gaps of `height` by `width` at
  # the location described by `row`, `column`.
  #
  # @param {stout-ui/util/packer/PackerStruct} p - The packer struct.
  #
  # @param {int} height - The height of the gap (in rows).
  #
  # @param {int} width - The width of the gap (in columns).
  #
  # @param {int} row - The row where the gap is located.
  #
  # @param {int} col - The column where the gap is located.
  #
  # @param {Array.<string>} The string `id`'s' of the item(s) below.
  ###
  itemsWithin: (height, width, row, col) ->
    ids = []
    c = col
    while c < col + width
      r = row
      while r < row + height
        id = @at r, c
        if id then ids.push id
        r++
      c++
    uniq ids


  ###*
  # Returns a set of `id`'s of the item(s) below a gap of size `height` by
  # `width` at `row` and `col`.
  #
  # @param {stout-ui/util/packer/PackerStruct} p - The packer struct.
  #
  # @param {int} height - The height of the gap (in rows).
  #
  # @param {int} width - The width of the gap (in columns).
  #
  # @param {int} row - The row where the gap is located.
  #
  # @param {int} col - The column where the gap is located.
  #
  # @param {Array.<string>} The string `id`'s' of the item(s) below in order
  # of increasing distance, so the first ID in the array will be the item
  # closest to the `id`, and the last will be the furthest down.
  ###
  _itemsBelow: (height, width, row, col) ->
    ids = []

    getItemsImmediatelyBelow = (height, width, row, col) ->

      # Get items immediately below.
      itemIds = @itemsWithin 1, width, row + height, col

      # Concat this new list of id's.
      ids = ids.concat itemIds

      for itemId in itemIds
        item = @i[itemId]
        getItemsImmediatelyBelow.call @, item.height, item.width, item.row, item.col

    getItemsImmediatelyBelow.call(@, height, width, row, col)

    uniq ids


  ###*
  # Fits a rectangle of the passed height and width within the packer.
  #
  # @param {stout-ui/util/packer/PackerStruct} p - The packer to fit the
  # rectangle to.
  #
  # @param {int} height - The height of the rectangle to fit.
  #
  # @param {int} width - The width of the rectangle to fit.
  #
  # @returns {Array.<int, int>} Returns an array of form `[row, col]` with the
  # row and column at-which the item fits.
  ###
  _fit: (height, width, startRow, endRow, startCol, endCol) ->
    row = startRow or 0
    while row < (endRow or @m.length)
      col = startCol or 0
      while col < (endCol or @w)
        if @_fits(height, width, row, col)
          return [row, col]
        col++
      row++
    return false


  ###*
  # Fills packer spaces of `height`, and `width` of `packer` starting at the
  # specified `row` and `column`. It does not check if the spaces are open.
  #
  # @param {stout-ui/util/packer/PackerStruct} p - The packer to fill.
  #
  # @param {int} height - The height of the fill..
  #
  # @param {int} width - The width of the fill..
  #
  # @param {int} row - The starting row.
  #
  # @param {int} col - The starting column.
  ###
  _fill: (height, width, row, col) ->
    r = row
    while r < row + height
      c = col
      while c < col + width
        @_set r, c
        c++
      r++


  ###*
  # Unfills the `packer` spaces of size `height` and `width`, starting at the
  # specified `row` and `col`.
  #
  # @param {stout-ui/util/packer/PackerStruct} p - The packer in-which to
  # unfill.
  #
  # @param {int} height - The height of the item to insert.
  #
  # @param {int} width - The width of the item to insert.
  #
  # @param {int} row - The row at-which to insert the item.
  #
  # @param {int} col - The column at which to insert the item.
  ###
  _unfill: (height, width, row, col) ->
    r = row
    while r < row + height
      c = col
      while c < col + width
        @_unset r, c
        c++
      r++


  ###*
  # Tests if a rectangle of size `height` and `width` fits within the specified
  # `packer` at `row` and `col`.
  #
  # @param {stout-ui/util/packer/PackerStruct} p - The packer in-which to
  # insert the item.
  #
  # @param {int} height - The height of the item to insert.
  #
  # @param {int} width - The width of the item to insert.
  #
  # @param {int} row - The row at-which to insert the item.
  #
  # @param {int} col - The column at which to insert the item.
  #
  # @returns {boolean} `true` if it fits, otherwise `false`.
  ###
  _fits: (height, width, row, col) ->

    # Inner function memoized to return fast results.
    innerFits = (height, width, row, col) ->
      # If this row exceeds the number of rows in the packer, return false.
      if row >= @m.length then return false

      # If this column exceeds the number of cols in the packer, return false.
      if col >= @w then return false

      # If this cell is already full then immediately return false.
      if @_isset(row, col) then return false

      # If checking a 1x1 sized item, and this cell is empty, return true.
      if height is 1 and width is 1 then return true

      ret = true

      if width > 1
        ret &= mFits.call(@, height, width - 1, row, col + 1)
      if height > 1
        ret &= mFits.call(@, height - 1, width, row + 1, col)
      if height > 1 and width > 1
        ret &= mFits.call(@, height - 1, width - 1, row + 1, col + 1)

      return !!ret

    # Resolver used to hash arguments to memoized function.
    resolver = (height, width, row, col) ->
      r = 'h' + height + 'w' + width + 'r' + row + 'c' + col

    # Create memoized function.
    mFits = memoize innerFits, resolver

    # Pass arguments to memoized function and return results.
    return mFits.call @, arguments...


  ###*
  # Checks if the specified `row` and `col` are set on the packer struct `p`.
  #
  # @param {stout-ui/util/packer/PackerStruct} packer - The packer in-which to
  # set the "full" bit.
  #
  # @param {int} row - The row.
  #
  # @param {int} col - The column.
  #
  # @returns {boolean} `true` if set, otherwise `false`.
  ###
  _isset: (row, col) ->
    !!(@m[row] & 1 << col)


  ###*
  # Sets the "full" bit at `row` and `col` for the passed `packer`.
  #
  # @param {stout-ui/util/packer/PackerStruct} p - The packer in-which to
  # set the "full" bit.
  #
  # @param {int} row - The row.
  #
  # @param {int} col - The column.
  ###
  _set: (row, col) ->
    @m[row] = @m[row] | 1 << col


  ###*
  # Unsets the "full" bit at `row` and `col` for the passed `packer`.
  #
  # @param {stout-ui/util/packer/PackerStruct} p - The packer in-which to
  # set the "full" bit.
  #
  # @param {int} row - The row.
  #
  # @param {int} col - The column.
  ###
  _unset: (row, col) ->
    @m[row] = @m[row] ^ 1 << col


  ###*
  #
  #
  #
  ###
  _print: (p) ->
    row = 0
    while row < @m.length
      col = 0
      out = ''
      while col < @w
        if !!(@m[row] & 1 << col)
          out += 'X'
        else
          out += '_'
        col++
      console.log out
      row++
    return
