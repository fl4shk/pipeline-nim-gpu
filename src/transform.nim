import mat4x4
import mat3x3
import vec3
import vec4
import fixedPt
import nimToPipelineCSrc/nimToPipelineC
import std/macros
import part

#proc `mkTransformDefaultFov`*[T](): T =
#  let resul
proc `defaultScale`(): Vec3[MyFixed] =
  let ret = Vec3[MyFixed](
    v: [
      mkMyFixed(1), # x
      mkMyFixed(1), # y
      mkMyFixed(1), # z
    ]
  )
  return ret

proc `defaultFov`*(): MyFixed =
  let ret = mkMyFixed(70)
  return ret


proc `doProject`(
  self: Mat4x4[MyFixed],
  model: Mat4x4[MyFixed],
  view: Mat4x4[MyFixed],
  v: Vec4[MyFixed],
): Vec4[MyFixed] {.cnomangle,craw: part(), cmainmhz: "100.0".} =
  let modelV = model.multH(v)
  let viewV = view.multH(modelV)
  let perspV = self * viewV
  return perspV


proc `testDoProjectPipelineC`(): Vec4[MyFixed]  =
  var self: Mat4x4[MyFixed]
  var model: Mat4x4[MyFixed]
  var view: Mat4x4[MyFixed]
  var v: Vec4[MyFixed]
  let ret = self.doProject(
    model=model,
    view=view,
    v=v,
  )
  result = ret

let a: string = toPipelineC(
  s=testDoProjectPipelineC,
  regularC=false,
  cppConstRefInp=true,
)
echo a
