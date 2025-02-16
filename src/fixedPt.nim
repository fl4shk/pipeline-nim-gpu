import std/macros
import miscMath
import nimToPipelineCSrc/nimToPipelineC

#type
#  FracWidth* = object
#    val*: uint
#
#type
#  FixedPt*[T; Fw: int] = object
#    fxpt*: T
#macro `FixedTypeName`(
#  T: untyped,
#  Fw: untyped,
#): untyped =



proc `fixedTypeName`*(
  T: string,
  FracWidth: int,
): string =
  var tnStr: string
  tnStr = "Fixed"
  case $T:
  of "uint8":
    tnStr.add "U"
    tnStr.add $(uint64(8 - FracWidth))
  of "uint16":
    tnStr.add "U"
    tnStr.add $(uint64(16 - FracWidth))
  of "uint32":
    tnStr.add "U"
    tnStr.add $(uint64(32 - FracWidth))
  of "uint64":
    tnStr.add "U"
    tnStr.add $(uint64(64 - FracWidth))
  of "int8":
    tnStr.add "I"
    tnStr.add $(uint64(8 - FracWidth))
  of "int16":
    tnStr.add "I"
    tnStr.add $(uint64(16 - FracWidth))
  of "int32":
    tnStr.add "I"
    tnStr.add $(uint64(32 - FracWidth))
  of "int64":
    tnStr.add "I"
    tnStr.add $(uint64(64 - FracWidth))
  else:
    assert(false, "invalid")

  tnStr.add "p"
  tnStr.add $FracWidth
  #let tn = ident("Fixed" & $T & "p" & $Fw)
  #let tn = ident(tnStr)
  #result = quote do:
  #  `tnStr`
  result = tnStr

proc `doTypedefFixedHelper`(
  T: NimNode,
  FracWidth: NimNode,
): string = 
  result = fixedTypeName($T, FracWidth.intVal)

macro `doTypedefFixed`*(
  T: typed,
  FracWidth: untyped,
): untyped =
  let myT = ident($T)
  let tn = ident(doTypedefFixedHelper(T, FracWidth))
  let setFromIntIdent = ident("setFromInt")
  let mkFromIntIdent = ident("mk" & tn.strVal)
  #let mkFromIntIdent = ident(
  #  tn.strVal
  #)
  let fwIdent = ident("fw")
  let leftIdent = ident("left")
  let rightIdent = ident("right")
  let selfIdent = ident("self")
  let valIdent = ident("val")
  let plusIdent = ident("plus" & tn.strVal)
  let plusOpIdent = ident("+")
  let minusIdent = ident("minus" & tn.strVal)
  let minusOpIdent = ident("-")
  let negateIdent = ident("negate" & tn.strVal)
  let negateOpIdent = ident("-")
  let starIdent = ident("star" & tn.strVal)
  let starOpIdent = ident("*")
  let slashIdent = ident("slash" & tn.strVal)
  let slashOpIdent = ident("/")
  let sqrtIdent = ident("sqrt" & tn.strVal)
  let sqrtTmplIdent = ident("sqrt")
  #let sqrtI32Ident = ident("sqrtI32" & tn.strVal)
  let ret = ident("ret")
  #let testRet = ident("testRet")
  let intTIdent = ident("IntT")
  #let fwVal = newLit(`Fw`)
  result = quote do:
    type
      `tn`* = object
        fxpt*: `T`
    template `fwIdent`*(
      `selfIdent`: `tn`,
    ): `T` = 
      `T`(`FracWidth`)
    proc `setFromIntIdent`*[`intTIdent`](
      `selfIdent`: `tn`,
      `valIdent`: `intTIdent`,
    ): `tn` =
      result.fxpt = `myT`(`valIdent`) shl `myT`(`selfIdent`.`fwIdent`)
    proc `mkFromIntIdent`*[`intTIdent`](
      `valIdent`: `intTIdent`,
    ): `tn` =
      var `ret`: `tn`
      `ret` = `ret`.`setFromIntIdent`(`valIdent`)
      result = `ret`

    #template `mkFromIntIdent`*(
    #  `selfIdent`: 
    #  `valIdent`: int
    #): `tn` =
    #  #var `ret`: `tn`
    #  #`ret`.`setFromIntIdent`(`valIdent`)
    #  result = `ret`
    proc `plusIdent`*(
      `leftIdent`: `tn`,
      `rightIdent`: `tn`,
    ): `tn` {.cnomangle.} =
      let `ret` = `tn`(fxpt: `leftIdent`.fxpt + `rightIdent`.fxpt)
      result = `ret`
    template `plusOpIdent`*(
      `leftIdent`: `tn`,
      `rightIdent`: `tn`,
    ): untyped = 
      `leftIdent`.`plusIdent` `rightIdent`
    proc `minusIdent`*(
      `leftIdent`: `tn`,
      `rightIdent`: `tn`,
    ): `tn` {.cnomangle.} =
      let `ret` = `tn`(fxpt: `leftIdent`.fxpt - `rightIdent`.fxpt)
      result = `ret`
    template `minusOpIdent`*(
      `leftIdent`: `tn`,
      `rightIdent`: `tn`,
    ): untyped = 
      `leftIdent`.`minusIdent` `rightIdent`
    proc `negateIdent`*(
      `selfIdent`: `tn`,
    ): `tn` {.cnomangle.} =
      let `ret` = `tn`(fxpt: -`selfIdent`.fxpt)
      result = `ret`
    template `negateOpIdent`*(
      `selfIdent`: `tn`,
    ): untyped = 
      self.negate
    proc `starIdent`*(
      `leftIdent`: `tn`,
      `rightIdent`: `tn`,
    ): `tn` {.cnomangle.} =
      let `ret` = `tn`(
        fxpt: (
          `T`(
            (
              int64(`leftIdent`.fxpt) * int64(`rightIdent`.fxpt)
            ) shr (
              `leftIdent`.`fwIdent`
            )
          )
        )
      )
      result = `ret`
    template `starOpIdent`*(
      `leftIdent`: `tn`,
      `rightIdent`: `tn`,
    ): untyped = 
      `leftIdent`.`starIdent` `rightIdent`
    proc `slashIdent`*(
      `leftIdent`: `tn`,
      `rightIdent`: `tn`,
    ): `tn` {.cnomangle.} =
      let `ret` = `tn`(fxpt: (
          #(
          #  `leftIdent`.fxpt * `rightIdent`.fxpt
          #) shr `leftIdent`.`fwIdent`
          `T`(
            (
              (int64(`leftIdent`.fxpt) shl `leftIdent`.`fwIdent`)
            ) div (
              int64(`rightIdent`.fxpt)
            )
          )
        )
      )
      result = `ret`
    template `slashOpIdent`*(
      `leftIdent`: `tn`,
      `rightIdent`: `tn`,
    ): untyped = 
      `leftIdent`.`slashIdent` `rightIdent`
    # algorithm borrowed from
    # https://github.com/chmike/fpsqrt/blob/master/fpsqrt.c#L69
    proc `sqrtIdent`*(
      `selfIdent`: `tn`,
    ): `tn` {.cnomangle.} =
      let `ret` = `tn`(fxpt: (
        #`T`(`selfIdent`.fxpt.sqrtI64() shl (`selfIdent`.`fwIdent` shl 1))
        `T`(sqrtI64(int64(`selfIdent`.fxpt) shl `selfIdent`.`fwIdent`))
      ))
      result = `ret`
    template `sqrtTmplIdent`*(
      `selfIdent`: `tn`,
    ): `tn` =
      `selfIdent`.`sqrtIdent`()
    #proc `sqrtIdent`*(
    #  `selfIdent`: `tn`,
    #  `testRet`: `tn`,
    #): `tn` {.cnomangle.} =
    #  let `ret` = `tn`(fxpt: (
    #    #`T`(`selfIdent`.fxpt.sqrtI64() shl (`selfIdent`.`fwIdent` shl 1))
    #    `T`(sqrtI64(int32(`selfIdent`.fxpt) shl `selfIdent`.`fwIdent`))
    #  ))
    #  result = `ret`
      

doTypedefFixed(int64, 32)
doTypedefFixed(int64, 16)
doTypedefFixed(int32, 8)
doTypedefFixed(int16, 4)

#type
#  MyFixed* = FixedI24p8
macro `MyFixed`*(): untyped =
  result = quote do:
    FixedI24p8

template `mkMyFixed`*[IntT](
  val: IntT
): MyFixed =
  mkFixedI24p8(val)

  #let tn = ident(FixedTypeName(T, Fw))
  #let tn = ident("Fixed" & $T
  #type
  #  Fixed
#type
#  Fixed(int32, 8)* = object
#    fxpt*: int32

#type
#  Testificate*[Fw: Natural] = object
#    a* = array[Fw, int]

#proc `fromtInt`*(
#  self: FixedPt,
#  x: int
#): FixedPt =
#  self.fxpt = x
#  result = self

#template `setFromInt`*(
#  self: FixedPt,
#  val: int
#) =
#  self.fxpt = val
