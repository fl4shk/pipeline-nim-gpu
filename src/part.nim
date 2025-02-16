import std/macros

macro `part`*(): untyped =
  result = quote do:
    "#pragma PART \"xc7a100tcsg324-1\"\n" 
