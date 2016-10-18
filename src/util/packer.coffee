###*
#
#
#
###
assign  = require 'lodash/assign'
memoize = require 'lodash/memoize'
reverse = require 'lodash/reverse'
uniq    = require 'lodash/uniq'


module.exports = packer =

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
  init: (height, width) ->
    if width > 32
      throw new Error 'Packer supports a maximum of 32 columns.'
    {m: new Uint32Array(height), w: width, i: {}}


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
  insert: (p, height, width, id) ->
    [row, col] = packer._fit(p, height, width)
    packer.insertAt p, height, width, row, col, id
    [row, col]


  insertWithin: (p, itemRow, itemCol, height, width, startRow, endRow, startCol, endCol, id, shifted = {}) ->

    prow = startRow + height #width
    pcol = startCol + width #height


    startRow = Math.max(0, startRow)
    endRow = Math.min(endRow, p.m.length)
    startCol = Math.max(0, startCol)
    endCol = Math.min(endCol, p.w)


    [row, col] = packer._fit(p, height, width, startRow, endRow, startCol, endCol)

    if row is undefined
      q = 0

      while q < height
        assign(shifted, packer.shiftDownNeighborsBelow p, height, width, prow + q, itemCol)
        q++

      [row, col] = packer._fit(p, height, width, startRow, endRow, startCol, endCol)
      shifted[id] = packer.insertAt(p, height, width, row, col, id)
      return shifted

      #[row, col] = packer._fit(p, height, width, startRow, endRow, startCol, endCol)
      #assign(shifted, packer.insertWithin.apply(@, arguments))
    else
      shifted[id] = packer.insertAt(p, height, width, row, col, id)
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
  insertAt: (p, height, width, row, col, id) ->
    packer._fill(p, height, width, row, col)
    p.i[id] = {height, width, row, col}


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
  remove: (p, id) ->
    item = p.i[id]
    if not item then return false
    packer._unfill p, item.height, item.width, item.row, item.col
    p.i[id] = null
    item


  ###*
  # Returns the current height (in rows) of the passed packer.
  #
  # @param {stout-ui/util/packer/PackerStruct} p - The packer.
  #
  # @returns {int} The packer's current height.
  ###
  height: (p) ->
    h = -1
    row = 0
    while row < p.m.length
      if p.m[row] and row > h then h = row
      row++
    return h + 1


  ###*
  # Returns the current width (in columns) of the passed packer.
  #
  # @param {stout-ui/util/packer/PackerStruct} p - The packer.
  #
  # @returns {int} The packer's current width.
  ###
  width: (p) ->
    w = -1
    row = 0
    while row < p.m.length
      col = 0
      while col < p.w
        if packer._isset(p, row, col) and col > w then w = col
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
  at: (p, pRow, pCol) ->
    for id, item of p.i
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
  shiftUp: (p, height, width, row, col) ->


  ###*
  # Constrains the passed `row` and `col` to the size of the grid for the item
  # specified by `id`.
  #
  #
  ###
  constrain: (p, id, row, col) ->
    item = p.i[id]
    row = Math.min(p.m.length - item.height, Math.max(0, row))
    col = Math.min(p.w - item.width, Math.max(0, col))
    [row, col]


  ###*
  # Returns array of coordinates of perimeter cells around the item specified
  # by `id`.
  #
  #
  ###
  perimeter: (p, cid, id) ->
    centerItem = p.i[cid]
    item = p.i[id]
    # Left option.
    [centerItem.col - item.width, centerItem.row]


  ###*
  #
  #
  #
  ###
  moveTo: (p, id, row, col) ->
    shifted = {}

    [row, col] = packer.constrain p, id, row, col

    item = packer.remove p, id

    overlappingItemIds = packer.itemsWithin(p, item.height, item.width, row, col)

    oItems = {}
    for oItemId in overlappingItemIds
      oItem = packer.remove p, oItemId
      oItems[oItemId] = oItem

    shifted[id] = packer.insertAt p, item.height, item.width, row, col, id

    for oItemId, oItem of oItems
      startRow = row - oItem.height
      endRow = row + item.height + oItem.height
      startCol = col - oItem.width
      endCol = col + item.width + oItem.width

      assign(shifted, packer.insertWithin p, oItem.row, oItem.col, oItem.height, oItem.width, startRow, endRow, startCol, endCol, oItemId, shifted)

    shifted


  ###*
  # Shifts-right the item specified by `id`.
  #
  # @param {stout-ui/util/packer/PackerStruct} p - The packer struct.
  #
  # @param {string} id - The `id` of the item to shift right.
  ###
  shiftRight: (p, id, cols = 1) ->
    shifted = packer.shiftNeighborsRightOrDown p, id, cols

    # Grow the target item.
    item = packer.remove p, id
    item = packer.insertAt p, item.height, item.width, item.row, item.col + cols, id

    shifted[id] = item

    shifted


  ###*
  # Finds the furthest right column filled by items with the passed `ids`.
  #
  #
  ###
  maxCol: (p, ids) ->
    max = 0
    for id in ids
      item = p.i[id]
      m = item.col + item.width
      if m > max then max = m
    max


  ###*
  # Finds the furthest left column filled by items with the passed `ids`.
  #
  #
  ###
  minCol: (p, ids) ->
    min = p.w
    for id in ids
      item = p.i[id]
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
  shiftNeighborsRightOrDown: (p, id, cols = 1) ->
    shifted = {}
    item = p.i[id]

    rightItems = packer.itemsRight(p, id)
    rightCol = packer.maxCol p, rightItems

    # Shift the neighbor right, since there's room.
    if rightCol < p.w
      console.log 'shift right!'
      immediatelyRightIds = packer.itemsImmediatelyRight(p, id)
      for rightId in immediatelyRightIds
        shifted[rightId] = packer._shiftRight p, rightId

    # Shift the neighbor down, since there's not room.
    else
      console.log 'shift down!'
      immediatelyRightIds = packer.itemsImmediatelyRight(p, id)
      firstRightItem = immediatelyRightIds[0]

      # Get items below first item immediately right.
      belowIds = reverse(packer.itemsBelow(p, ))
      rows = item.row + item.height

      for belowId in belowIds


        while rows-- > 0
          belowIds = reverse(packer.itemsBelow(p, id))
          for belowId in belowIds
            shifted[belowId] = packer._shiftDown p, belowId
          shifted[id] = packer._shiftDown p, id


        shifted[rightId] = packer._shiftDown p, rightId

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
  growDown: (p, id, rows = 1) ->
    shifted = {}

    while rows-- > 0
      belowIds = reverse(packer.itemsBelow(p, id))
      for belowId in belowIds
        shifted[belowId] = packer._shiftDown p, belowId
      item = packer.remove p, id
      packer.insertAt p, item.height + 1, item.width, item.row, item.col, id

    shifted


  shiftDownNeighborsBelow: (p, height, width, row, col) ->
    shifted = {}

    belowIds = reverse(packer._itemsBelow(p, height, width, row, col))
    for belowId in belowIds
      shifted[belowId] = packer._shiftDown p, belowId

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
  growRight: (p, id, cols = 1) ->
    shifted = packer.shiftNeighborsRightOrDown p, id, cols

    # Grow the target item.
    item = packer.remove p, id
    packer.insertAt p, item.height, item.width + cols, item.row, item.col, id

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
  _shiftRightOrDown: (p, id, rows, shifted) ->
    item = p.i[id]
    if item.col + item.width + 1 <= p.w
      shifted[id] = packer._shiftRight p, id
    else
      while rows-- > 0
        belowIds = reverse(packer.itemsBelow(p, id))
        for belowId in belowIds
          shifted[belowId] = packer._shiftDown p, belowId
        shifted[id] = packer._shiftDown p, id
      return p.i[id]


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
  _shiftRight: (p, id) ->
    item = packer.remove p, id
    packer.insertAt p, item.height, item.width, item.row, item.col + 1, id


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
  _shiftDown: (p, id) ->
    item = packer.remove p, id
    packer.insertAt p, item.height, item.width, item.row + 1, item.col, id


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
  itemsWithin: (p, height, width, row, col) ->
    ids = []
    c = col
    while c < col + width
      r = row
      while r < row + height
        id = packer.at p, r, c
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
  itemsBelow: (p, id) ->
    item = p.i[id]
    {height, width, row, col} = item
    packer._itemsBelow p, height, width, row, col


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
  _itemsBelow: (p, height, width, row, col) ->
    ids = []

    getItemsImmediatelyBelow = (height, width, row, col) ->

      # Get items immediately below.
      itemIds = packer.itemsWithin p, 1, width, row + height, col

      # Concat this new list of id's.
      ids = ids.concat itemIds

      for itemId in itemIds
        item = p.i[itemId]
        getItemsImmediatelyBelow item.height, item.width, item.row, item.col

    getItemsImmediatelyBelow(height, width, row, col)

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
  itemsRight: (p, id) ->
    item = p.i[id]
    {height, width, row, col} = item
    packer._itemsRight p, height, width, row, col


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
  _itemsRight: (p, height, width, row, col) ->
    ids = []

    getItemsImmediatelyRight = (height, width, row, col) ->

      # Get items immediately below.
      itemIds = packer._itemsImmediatelyRight(p, height, width, row, col)

      # Concat this new list of id's.
      ids = ids.concat itemIds

      for itemId in itemIds
        item = p.i[itemId]
        getItemsImmediatelyRight item.height, item.width, item.row, item.col

    getItemsImmediatelyRight(height, width, row, col)

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
  itemsImmediatelyRight: (p, id) ->
    item = p.i[id]
    {height, width, row, col} = item
    packer._itemsImmediatelyRight p, height, width, row, col


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
  _itemsImmediatelyRight: (p, height, width, row, col) ->
    packer.itemsWithin p, height, 1, row, col + width


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
  _fit: (p, height, width, startRow, endRow, startCol, endCol) ->
    row = startRow or 0
    while row < (endRow or p.m.length)
      col = startCol or 0
      while col < (endCol or p.w)
        if packer._fits(p, height, width, row, col)
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
  _fill: (p, height, width, row, col) ->
    r = row
    while r < row + height
      c = col
      while c < col + width
        packer._set p, r, c
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
  _unfill: (p, height, width, row, col) ->
    r = row
    while r < row + height
      c = col
      while c < col + width
        packer._unset p, r, c
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
  _fits: (p, height, width, row, col) ->

    # Inner function memoized to return fast results.
    innerFits = (p, height, width, row, col) ->
      # If this row exceeds the number of rows in the packer, return false.
      if row >= p.m.length then return false

      # If this column exceeds the number of cols in the packer, return false.
      if col >= p.w then return false

      # If this cell is already full then immediately return false.
      if packer._isset(p, row, col) then return false

      # If checking a 1x1 sized item, and this cell is empty, return true.
      if height is 1 and width is 1 then return true

      ret = true

      if width > 1
        ret &= mFits(p, height, width - 1, row, col + 1)
      if height > 1
        ret &= mFits(p, height - 1, width, row + 1, col)
      if height > 1 and width > 1
        ret &= mFits(p, height - 1, width - 1, row + 1, col + 1)

      return !!ret

    # Resolver used to hash arguments to memoized function.
    resolver = (p, height, width, row, col) ->
      r = 'h' + height + 'w' + width + 'r' + row + 'c' + col

    # Create memoized function.
    mFits = memoize innerFits, resolver

    # Pass arguments to memoized function and return results.
    return mFits arguments...


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
  _isset: (p, row, col) ->
    !!(p.m[row] & 1 << col)


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
  _set: (p, row, col) ->
    p.m[row] = p.m[row] | 1 << col


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
  _unset: (p, row, col) ->
    p.m[row] = p.m[row] ^ 1 << col


  ###*
  #
  #
  #
  ###
  _print: (p) ->
    row = 0
    while row < p.m.length
      col = 0
      out = ''
      while col < p.w
        if !!(p.m[row] & 1 << col)
          out += 'X'
        else
          out += '_'
        col++
      console.log out
      row++
    return
