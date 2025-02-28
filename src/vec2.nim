import array
import miscMath

type
  Vec2*[T] = object
    v*: Array(2, T)

const
  vec2IdxX = 0
  vec2IdxY = 1


template `[]`(
  self: Vec2,
  idx: untyped
): untyped =
  self.v[idx] 

template `[]=`(
  self: Vec2,
  idx: untyped,
  val: untyped,
): untyped =
  self.v[idx] = val

template `x`*(
  self: Vec2,
): untyped =
  self[vec2IdxX]
template `x=`*(
  self: Vec2,
  val: untyped
) =
  self[vec2IdxX] = val

template `y`*(
  self: Vec2,
): untyped =
  self[vec2IdxY]
template `y=`*(
  self: Vec2,
  val: untyped
) =
  self[vec2IdxY] = val

template `buildHomogeneous`*[T](
  v: Vec2[T],
): Vec2[T] =
  Vec2[T](v: [v[0], v[1], v[2], fromInt(1)])

proc `plus`*[T](
  left: Vec2[T],
  right: Vec2[T],
): Vec2[T] =
  for i in 0 ..< result.v.len():
    result[i] = left[i] + right[i]

template `+`*(
  left: Vec2,
  right: Vec2,
): Vec2 =
  left.plus right

proc `minus`*[T](
  left: Vec2[T],
  right: Vec2[T],
): Vec2[T] =
  for i in 0 ..< result.v.len():
    result[i] = left[i] - right[i]

template `-`*(
  left: Vec2,
  right: Vec2,
): Vec2 =
  left.minus right

proc `negate`*[T](
  self: Vec2[T],
): Vec2[T] =
  for i in 0 ..< result.v.len():
    result[i] = -left[i]

template `-`*(
  self: Vec2,
): Vec2 =
  self.negate

proc `star`*[T](
  left: Vec2[T],
  right: T,
): Vec2[T] =
  for i in 0 ..< result.v.len():
    result[i] = left[i] * right

template `*`*(
  left: Vec2,
  right: typed,
): Vec2 =
  left.star right

proc `slash`*[T](
  left: Vec2[T],
  right: T,
): Vec2[T] =
  for i in 0 ..< result.v.len():
    result[i] = left[i] div right

template `/`*(
  left: Vec2,
  right: typed,
): Vec2 =
  left.slash right


proc `dot`*[T](
  #self: untyped,
  left: Vec2[T],
  right: Vec2[T],
): T = 
  #result.fxpt = 0
  #result.setFromInt(1)
  result = result.setFromInt(int32(0))
  for i in 0 ..< left.v.len():
    result = result + (left.v[i] * right.v[i])
  #someRet

#proc `mag`*[T](
#  self: Vec2[T]
#): T = 
#  return sqrt(self.dot(self))
#
#proc `norm`*[T](
#  self: Vec2[T]
#): T =
#  return self / self.mag()
template `mag`*(
  self: Vec2
): untyped = 
  self.dot(self).sqrt()

template `norm`*(
  self: Vec2
): untyped =
  self / self.mag()
