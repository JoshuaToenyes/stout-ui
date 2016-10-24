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
  # Shifts-up items to fill a gap of size `height` by `width` at `row` and
  # `col`.
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
  ###
  shiftUp: (height, width, row, col) ->


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
  # Returns array of coordinates of perimeter cells around the item specified
  # by `id`.
  #
  #
  ###
  perimeter: (cid, id) ->
    centerItem = @i[cid]
    item = @i[id]
    # Left option.
    [centerItem.col - item.width, centerItem.row]


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


  # fillIn: (items, row, col, height, width) ->
  #   shifted = {}
  #
  #   for id of items
  #     @remove id
  #
  #   for id, item of items
  #     startRow = row - item.height
  #     endRow = row + height + item.height
  #     startCol = col - item.width
  #     endCol = col + width + item.width
  #
  #     assign(shifted, @insertWithin item.row, item.col, item.height, item.width, startRow, endRow, startCol, endCol, id, shifted)
  #
  #   shifted





  ###*
  # Resizes and moves an item.
  #
  # @param {stout-ui/util/packer/PackerStruct} p - The packer struct.
  #
  # @param {string} id - The `id` of the item to shift right.
  #
  # @param {number} width - The new width in rows of the resized item.
  #
  # @param {number} height - The new height in rows of the resized item.
  #
  # @param {number} row - The new row position of the resized item.
  #
  # @param {number} col - The new col position of the resized item.
  ###
  resize: (id, width, height, row, col) ->


  ###*
  # Shifts-right the item specified by `id`.
  #
  # @param {stout-ui/util/packer/PackerStruct} p - The packer struct.
  #
  # @param {string} id - The `id` of the item to shift right.
  ###
  shiftRight: (id, cols = 1) ->
    shifted = @shiftNeighborsRightOrDown id, cols

    # Grow the target item.
    item = @remove id
    item = @insertAt item.height, item.width, item.row, item.col + cols, id

    shifted[id] = item

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
  # Shifts the neighbors of the items specified by `id`, `cols` to the right,
  # or if doing so pushes it out of the grid, down.
  #
  # @param {stout-ui/util/packer/PackerStruct} p - The packer struct.
  #
  # @param {string} id - The `id` of the item who's neighbors should be shifted
  # right
  #
  # @param {int} cols - The number of columns to shift right.
  #
  # @returns {object} Set of items shifted right keyed with the `id` of the
  # shifted item, with values which describe its new position in the form,
  # `{height, width, row, col}`.
  ###
  shiftNeighborsRightOrDown: (id, cols = 1) ->
    shifted = {}
    item = @i[id]

    rightItems = @itemsRight(id)
    rightCol = @maxCol rightItems

    # Shift the neighbor right, since there's room.
    if rightCol < @w
      console.log 'shift right!'
      immediatelyRightIds = @itemsImmediatelyRight(id)
      for rightId in immediatelyRightIds
        shifted[rightId] = @_shiftRight rightId

    # Shift the neighbor down, since there's not room.
    else
      console.log 'shift down!'
      immediatelyRightIds = @itemsImmediatelyRight(id)
      firstRightItem = immediatelyRightIds[0]

      # Get items below first item immediately right.
      belowIds = reverse(@itemsBelow()) # THIS WONT WORK PROBABLY
      rows = item.row + item.height

      for belowId in belowIds


        while rows-- > 0
          belowIds = reverse(@itemsBelow(id))
          for belowId in belowIds
            shifted[belowId] = @_shiftDown belowId
          shifted[id] = @_shiftDown id


        shifted[rightId] = @_shiftDown rightId

    # # Shifts the immediately-right neighbors right, if doing so will not exceed
    # # the width of the grid. If it does, the neighbor (and its neighbors below)
    # # are shifted down.
    # innershift = (id, downShift, skip) ->
    #   currentItem = p.i[id]
    #   immediatelyRightIds = packer.itemsImmediatelyRight(p, id)
    #
    #   # Recurse to shift the furthest-right first.
    #   for rightId in immediatelyRightIds
    #     innershift(rightId, currentItem.row + currentItem.height)
    #
    #   # After recursing to the furthest right, shift this item, if not skipping.
    #   if not skip
    #     packer._shiftRightOrDown p, id, downShift - currentItem.row, shifted
    #
    # # We can only shift one column at a time, so call once for each shift.
    # c = cols
    # while c-- > 0
    #   innershift(id, item.row + item.height, true)

    shifted


  ###*
  # Grows the item with `id`, `rows` down.
  #
  # @param {stout-ui/util/packer/PackerStruct} p - The packer struct.
  #
  # @param {string} id - The `id` of the item to grow down.
  #
  # @param {int} rows - The number of rows to grow down.
  #
  # @returns {object} Set of items shifted down keyed with the `id` of the
  # shifted item, with values which describe its new position in the form,
  # `{height, width, row, col}`.
  ###
  growDown: (id, rows = 1) ->
    shifted = {}

    while rows-- > 0
      belowIds = reverse(@itemsBelow(id))
      for belowId in belowIds
        shifted[belowId] = @_shiftDown belowId
      item = @remove id
      @insertAt item.height + 1, item.width, item.row, item.col, id

    shifted


  shiftDownNeighborsBelow: (height, width, row, col) ->
    shifted = {}

    belowIds = reverse(@_itemsBelow(height, width, row, col))
    for belowId in belowIds
      shifted[belowId] = @_shiftDown belowId

    shifted


  ###*
  # Grows the item with `id`, `cols` right.
  #
  # @param {stout-ui/util/packer/PackerStruct} p - The packer struct.
  #
  # @param {string} id - The `id` of the item to grow right
  #
  # @param {int} cols - The number of columns to grow right.
  #
  # @returns {object} Set of items shifted right keyed with the `id` of the
  # shifted item, with values which describe its new position in the form,
  # `{height, width, row, col}`.
  ###
  growRight: (id, cols = 1) ->
    shifted = @shiftNeighborsRightOrDown id, cols

    # Grow the target item.
    item = @remove id
    @insertAt item.height, item.width + cols, item.row, item.col, id

    shifted


  ###*
  # Shifts the item given by `id`, `cols` columns to the right, if it doesn't
  # exceed the width of the grid. If shifting the item to the right `cols`
  # columns, then it is shifted down `rows`.
  #
  # @param {stout-ui/util/packer/PackerStruct} p - The packer struct.
  #
  # @param {string} id - The `id` of the item to shift right
  #
  # @param {int} rows - The number of rows to shift down if shifting-right
  # exceeds the width of the grid.
  #
  # @param {int} cols - The number of columns to shift right.
  #
  # @returns {object} An object which describes the new position and size of the
  # shifted item in the form, `{height, width, row, col}`.
  ###
  _shiftRightOrDown: (id, rows, shifted) ->
    item = @i[id]
    if item.col + item.width + 1 <= @w
      shifted[id] = @_shiftRight id
    else
      while rows-- > 0
        belowIds = reverse(@itemsBelow(id))
        for belowId in belowIds
          shifted[belowId] = @_shiftDown belowId
        shifted[id] = @_shiftDown id
      return @i[id]


  ###*
  # Shifts the item given by `id`, `cols` columns to the right.
  #
  # @param {stout-ui/util/packer/PackerStruct} p - The packer struct.
  #
  # @param {string} id - The `id` of the item to shift right
  #
  # @returns {object} An object which describes the new position and size of the
  # shifted item in the form, `{height, width, row, col}`.
  ###
  _shiftRight: (id) ->
    item = @remove id
    @insertAt item.height, item.width, item.row, item.col + 1, id


  ###*
  # Shifts the passed item down.
  #
  # @param {stout-ui/util/packer/PackerStruct} p - The packer struct.
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
  # Returns set of id's of all items below the item with id `id`.
  #
  # @param {stout-ui/util/packer/PackerStruct} p - The packer struct.
  #
  # @param {string} id - The `id` of the item for-which to find items below.
  #
  # @param {Array.<string>} The string `id`'s' of the item(s) below in order
  # of increasing distance, so the first ID in the array will be the item
  # closest to the item given by `id`, and the last will be the furthest down.
  ###
  itemsBelow: (id) ->
    item = @i[id]
    {height, width, row, col} = item
    @_itemsBelow height, width, row, col


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
  # Returns set of id's of all items to the right of the item given by `id`.
  #
  # @param {stout-ui/util/packer/PackerStruct} p - The packer struct.
  #
  # @param {string} id - The `id` of the item for-which to find items right.
  #
  # @param {Array.<string>} The string `id`'s' of the item(s) to the right in
  # order of increasing distance, so the first ID in the array will be the item
  # closest to item given by `id`, and the last will be the furthest right.
  ###
  itemsRight: (id) ->
    item = @i[id]
    {height, width, row, col} = item
    @_itemsRight height, width, row, col


  ###*
  # Returns a set of `id`'s of the item(s) to the right of a gap of size
  # `height` by `width` at `row` and `col`.
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
  # @param {Array.<string>} The string `id`'s' of the item(s) to the right in
  # order of increasing distance, so the first ID in the array will be the item
  # closest to item given by `id`, and the last will be the furthest right.
  ###
  _itemsRight: (height, width, row, col) ->
    ids = []

    getItemsImmediatelyRight = (height, width, row, col) ->

      # Get items immediately below.
      itemIds = @_itemsImmediatelyRight(height, width, row, col)

      # Concat this new list of id's.
      ids = ids.concat itemIds

      for itemId in itemIds
        item = @i[itemId]
        getItemsImmediatelyRight.call @ item.height, item.width, item.row, item.col

    getItemsImmediatelyRight.call(@, height, width, row, col)

    uniq ids


  ###*
  # Returns set of id's of all items immediately to the right of the item given
  # by `id`.
  #
  # @param {stout-ui/util/packer/PackerStruct} p - The packer struct.
  #
  # @param {string} id - The `id` of the item for-which to find items right.
  #
  # @param {Array.<string>} The string `id`'s' of the item(s) to the right in
  # order of increasing distance, so the first ID in the array will be the item
  # closest to item given by `id`, and the last will be the furthest right.
  ###
  itemsImmediatelyRight: (id) ->
    item = @i[id]
    {height, width, row, col} = item
    @_itemsImmediatelyRight height, width, row, col


  ###*
  # Gets items immediately to the right of the rectangle described of size
  # `height` by `width` positioned at `row`, `col`.
  #
  # @param {stout-ui/util/packer/PackerStruct} p - The packer struct.
  #
  # @param {int} height - The height of the rectangle (in rows).
  #
  # @param {int} width - The width of the rectangle (in columns).
  #
  # @param {int} row - The row where the rectangle is located.
  #
  # @param {int} col - The column where the rectangle is located.
  #
  # @param {Array.<string>} The string `id`'s' of the item(s) immediately to
  # the right.
  ###
  _itemsImmediatelyRight: (height, width, row, col) ->
    @itemsWithin height, 1, row, col + width


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
