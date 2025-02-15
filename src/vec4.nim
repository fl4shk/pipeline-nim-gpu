import array
import vec3

type
  Vec4*[T] = object
    v*: Array(4, T)

const
  vec4IdxX = 0
  vec4IdxY = 1
  vec4IdxZ = 2
  vec4IdxW = 3

template `[]`(
  self: Vec4,
  idx: untyped
): untyped =
  self.v[idx] 

template `[]=`(
  self: Vec4,
  idx: untyped,
  val: untyped,
): untyped =
  self.v[idx] = val

template `x`*(
  self: Vec4,
): untyped =
  self[vec4IdxX]
template `x=`*(
  self: Vec4,
  val: untyped
) =
  self[vec4IdxX] = val

template `y`*(
  self: Vec4,
): untyped =
  self[vec4IdxY]
template `y=`*(
  self: Vec4,
  val: untyped
) =
  self[vec4IdxY] = val

template `z`*(
  self: Vec4,
): untyped =
  self[vec4IdxZ]
template `z=`*(
  self: Vec4,
  val: untyped
) =
  self[vec4IdxZ] = val
template `w`*(
  self: Vec4,
): untyped =
  self[vec4IdxW]
template `w=`*(
  self: Vec4,
  val: untyped
) =
  self[vec4IdxW] = val

template `buildHomogeneous`*[T](
  v: Vec3[T],
): Vec4[T] =
  Vec4[T](v: [v[0], v[1], v[2], fromInt(1)])

proc `plus`*[T](
  left: Vec4[T],
  right: Vec4[T],
): Vec4[T] =
  for i in 0 ..< result.v.len():
    result[i] = left[i] + right[i]

template `+`*(
  left: Vec4,
  right: Vec4,
): Vec4 =
  left.plus right

proc `minus`*[T](
  left: Vec4[T],
  right: Vec4[T],
): Vec4[T] =
  for i in 0 ..< result.v.len():
    result[i] = left[i] - right[i]

template `-`*(
  left: Vec4,
  right: Vec4,
): Vec4 =
  left.minus right

proc `negate`*[T](
  self: Vec4[T],
): Vec4[T] =
  for i in 0 ..< result.v.len():
    result[i] = -left[i]

template `-`*(
  self: Vec4,
): Vec4 =
  self.negate

proc `star`*[T](
  left: Vec4[T],
  right: T,
): Vec4[T] =
  for i in 0 ..< result.v.len():
    result[i] = left[i] * right

template `*`*(
  left: Vec4,
  right: typed,
): Vec4 =
  left.star right

proc `slash`*[T](
  left: Vec4[T],
  right: T,
): Vec4[T] =
  for i in 0 ..< result.v.len():
    result[i] = left[i] div right

template `/`*(
  left: Vec4,
  right: typed,
): Vec4 =
  left.slash right


proc `dot`*[T](
  #self: untyped,
  left: Vec4[T],
  right: Vec4[T],
): T = 
  #result.fxpt = 0
  #result.setFromInt(1)
  result = result.setFromInt(int32(0))
  for i in 0 ..< left.v.len():
    result = result + (left.v[i] * right.v[i])
  #someRet

#proc `cross`*[T](
#  left: Vec4[T],
#  right: Vec4[T],
#): Vec4[T] =
#  result.x = (left.y * right.z) - (left.z * right.y)
#  result.y = (left.z * right.x) - (left.x * right.z)
#  result.z = (left.x * right.y) - (left.y * right.x)
