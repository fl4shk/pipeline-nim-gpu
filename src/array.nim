import std/macros

macro `Array`*(
  I: untyped,
  T: untyped,
): untyped =
  result = quote do:
    array[`I`, `T`]
