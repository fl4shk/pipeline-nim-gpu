import array
import std/macros

type
  Vec3*[T] = object
    #x*: T
    #y*: T
    #z*: T
    v*: Array(3, T)

const
  vec3IdxX = 0
  vec3IdxY = 1
  vec3IdxZ = 2

template `[]`(
  self: Vec3,
  idx: untyped
): untyped =
  self.v[idx] 

template `[]=`(
  self: Vec3,
  idx: untyped,
  val: untyped,
): untyped =
  self.v[idx] = val

template `x`*(
  self: Vec3,
): untyped =
  self[vec3IdxX]
template `x=`*(
  self: Vec3,
  val: untyped
) =
  self[vec3IdxX] = val

template `y`*(
  self: Vec3,
): untyped =
  self[vec3IdxY]
template `y=`*(
  self: Vec3,
  val: untyped
) =
  self[vec3IdxY] = val

template `z`*(
  self: Vec3,
): untyped =
  self[vec3IdxZ]
template `z=`*(
  self: Vec3,
  val: untyped
) =
  self[vec3IdxZ] = val


proc `plus`*[T](
  left: Vec3[T],
  right: Vec3[T],
): Vec3[T] =
  for i in 0 ..< result.v.len():
    result[i] = left[i] + right[i]

template `+`*(
  left: Vec3,
  right: Vec3,
): Vec3 =
  left.plus right

proc `minus`*[T](
  left: Vec3[T],
  right: Vec3[T],
): Vec3[T] =
  for i in 0 ..< result.v.len():
    result[i] = left[i] - right[i]

template `-`*(
  left: Vec3,
  right: Vec3,
): Vec3 =
  left.minus right

proc `negate`*[T](
  self: Vec3[T],
): Vec3[T] =
  for i in 0 ..< result.v.len():
    result[i] = -left[i]

template `-`*(
  self: Vec3,
): Vec3 =
  self.negate

proc `star`*[T](
  left: Vec3[T],
  right: T,
): Vec3[T] =
  for i in 0 ..< result.v.len():
    result[i] = left[i] * right

template `*`*(
  left: Vec3,
  right: typed,
): Vec3 =
  left.star right


proc `slash`*[T](
  left: Vec3[T],
  right: T,
): Vec3[T] =
  for i in 0 ..< result.v.len():
    result[i] = left[i] div right

template `/`*(
  left: Vec3,
  right: typed,
): Vec3 =
  left.slash right


#proc `dot`*[T](
#  #someRet: T,
#  left: Vec3[T],
#  right: Vec3[T],
#): T = 
#  #result = T(0)
#  #result = quote do:
#  #result = fromInt(0)
#  #result = 0
#  result = result.fromInt(0)
#  for i in 0 ..< left.v.len():
#    result = result + (left.v[i] * right.v[i])
#  #`someRet`
proc `dot`*[T](
  #self: untyped,
  left: Vec3[T],
  right: Vec3[T],
): T = 
  #result.fxpt = 0
  #result.setFromInt(1)
  result = result.setFromInt(int32(0))
  for i in 0 ..< left.v.len():
    result = result + (left.v[i] * right.v[i])
  #someRet

proc `cross`*[T](
  left: Vec3[T],
  right: Vec3[T],
): Vec3[T] =
  result.x = (left.y * right.z) - (left.z * right.y)
  result.y = (left.z * right.x) - (left.x * right.z)
  result.z = (left.x * right.y) - (left.y * right.x)

template `mag`*(
  self: Vec3
): untyped = 
  self.dot(self).sqrt()

template `norm`*(
  self: Vec3
): untyped =
  self / self.mag()
