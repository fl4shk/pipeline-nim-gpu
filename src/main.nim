import std/macros
import array
import fixedPt
import vec3
import vec4
import mat3x3
import miscMath
import nimToPipelineCSrc/nimToPipelineC

#doTypedefFixed(int32, 8)

#var a: FixedI24p8
#var b: FixedI16p4
##template `fromInt`*(
##  toSet: untyped,
##  x: int
##) =
##  toSet = x
#template `setFromInt`*(
#  self: int,
#  x: int
#) =
#  self = x

macro part(): untyped =
  result = quote do:
    "#pragma PART \"xc7a100tcsg324-1\"\n" 

proc `myMain`*(
  a: Vec4[FixedI24p8],
  b: Vec4[FixedI24p8],
): FixedI24p8 {.cnomangle,craw: part,cmainmhz: "100.0".} =
  #result = a.cross b
  #result.dot(a, b)
  #result.Fw
  #result.setFromInt(int32(result.fw))
  #result = dot[FixedI24p8](a, b)
  #result = a + b
  #result = a.dot b
  #var temp: FixedI24p8
  #result = a.x * (temp.setFromInt(1) / b.x.sqrt)
  let ret = (a.dot b) / (mkFixedI24p8(1) / b.x.sqrt())
  result = ret
  #result = (temp.setFromInt(1) / b.x.sqrt())
  #result = b.x.sqrt()


proc `outerMain`*(
  a: Vec4[FixedI24p8],
  b: Vec4[FixedI24p8],
): int  =
  #let b = Vec4[FixedI24p8](
  #  v: [
  #    5, 6, 7, 9
  #  ]
  #)
  #var temp: Testificate[1]#(a: [3])
  #var c: Testificate[8]
  result = myMain(a=a, b=b).fxpt #+ temp.a[0]

proc `outerOuterMain`*(): int =
  #var temp: FixedI24p8
  let a = Vec4[FixedI24p8](
    v: [
      FixedI24p8(fxpt: 1),
      FixedI24p8(fxpt: 2),
      FixedI24p8(fxpt: 3),
      FixedI24p8(fxpt: 5),
      #FixedI24p8().setFromInt(1),
      #FixedI24p8().setFromInt(2),
      #FixedI24p8().setFromInt(3),
      #FixedI24p8().setFromInt(5),
    ]
  )
  let b = Vec4[FixedI24p8](
    v: [
      #FixedI24p8().setFromInt(5),
      #FixedI24p8().setFromInt(6),
      #FixedI24p8().setFromInt(7),
      #FixedI24p8().setFromInt(9),
      FixedI24p8(fxpt: 1),
      FixedI24p8(fxpt: 2),
      FixedI24p8(fxpt: 3),
      FixedI24p8(fxpt: 5),
    ],
  )
  result = outerMain(a=a, b=b)
  #result = 3

var temp: FixedI24p8
temp = temp.setFromInt(200)
#echo sqrtI64(2 shl 16)
echo temp.sqrt.fxpt
echo float(temp.sqrt.fxpt) / float(1 shl 8)

#echo toPipelineC(
#  s=outerOuterMain,
#  regularC=false,
#  cppConstRefInp=true,
#)
#echo outerOuterMain()
#echo a.fw
#echo typeof(a.fw)
#echo b.fw
#echo typeof(b.fw)
