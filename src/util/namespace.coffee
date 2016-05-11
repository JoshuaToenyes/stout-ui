module.exports = (namespace, obj) ->

  # Split the namespace by periods.
  ns = namespace.split /\./g

  # Starting at the global window object, travel down the namespace, creating
  # it as required.
  parent = window
  i = 0
  while i < ns.length - 1
    n = ns[i]
    parent[n] = parent[n] or {}
    parent = parent[n]
    i++

  # Expose the passed object, if it doesn't already exist.
  n = ns[i]
  if parent[n]
    throw new Error "Refuse to redefine namespace #{namespace}."
  else
    parent[n] = obj
