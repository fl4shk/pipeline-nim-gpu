import std/macros
import fixedPt
import vec4
import vec3
import vec2
import mat4x4
import array
import vert
import transform

const
  triVertSize*: uint = 3

type
  TriIdx* = object
    v*: array[triVertSize, uint16]

#type
#  TriVert* = object
#    v*: array[triVertSize, Vert]

type
  Tri* = object
    model*: Mat4x4[MyFixed]
    v*: array[triVertSize, Vert]
    projV*: array[triVertSize, Vert]
    ndcV*: array[triVertSize, Vert]
    screenV*: array[triVertSize, Vert]
    rwArr: array[triVertSize, MyFixed]


proc `doProjectEtcInner`(
  self: Tri,
  view: Mat4x4[MyFixed],
  perspective: Mat4x4[MyFixed],
): Tri =
  #var ret: Tri = self

  var ret: Tri = self
  for i in 0 ..< triVertSize:
    ret.projV[i].v = perspective.doProject(
      model=ret.model,
      view=view,
      v=ret.v[i].v
    )
    ret.projV[i].uv = ret.v[i].uv

    let fxOne = mkMyFixed(1)

    ret.rwArr[i] = fxOne / ret.projV[i].v.w

  result = ret

macro `doProjectEtc`*(
  self: Tri,
  view: Mat4x4[MyFixed],
  perspective: Mat4x4[MyFixed],
): untyped = 
  result = quote do:
    self = self.doProjectEtcInner(view=view, perspective=perspecitve)

proc `perspDivInner`(
  self: Tri
): Tri =
  let ret: Tri = self

  let fxOne = mkMyFixed(1)
  for i in 0 ..< triVertSize:
    #ret.rwArr[i] = my_recip(ret.projV[i].v.w)
    ret.rwArr[i] = fxOne / ret.projV[i].v.w
    ret.ndcV[i].v.x = (
      #mult_cx_rw
      (
        ret.projV[i].v.x * ret.rwArr[i]
      )
    )
    ret.ndcV[i].v.y = (
      #mult_cx_rw
      (
        ret.projV[i].v.y * ret.rwArr[i]
      )
    )
    ret.ndcV[i].v.z = (
      #mult_cx_rw
      (
        ret.projV[i].v.z * ret.rwArr[i]
      )
    )
    ret.ndcV[i].v.w = (
      ret.projV[i].v.w
    )
    ret.ndcV[i].uv.x = (
      #mult_cx_rw
      (
        ret.projV[i].uv.x * ret.rwArr[i]
      )
    )
    ret.ndcV[i].uv.y = (
      #mult_cx_rw
      (
        ret.projV[i].uv.y * ret.rwArr[i]
      )
    )
    ret.screenV[i].v.x = (
      (
        (ret.ndcV[i].v.x + fxOne) * HALF_SCREEN_SIZE_2D.x
      )
    )
    ret.screenV[i].v.y = (

      (ret.ndcV[i].v.y + fxOne) * HALF_SCREEN_SIZE_2D.y
    )
    ret.screenV[i].v.z = (
      ret.ndcV[i].v.z
    )
    ret.screenV[i].v.w = ret.ndcV[i].v.w
    ret.screenV[i].uv = ret.ndcV[i].uv

  result = ret

macro `perspDiv`*(
  self: Tri,
): untyped = 
  result = quote do:
    self = self.perspDivInner()
