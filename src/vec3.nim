import array

type
  Vec3*[T] = object
    #x*: T
    #y*: T
    #z*: T
    v: Array(3, T)

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
) =
  self[0]
template `x=`*(
  self: Vec3,
  val: untyped
) =
  self[0] = val

template `y`*(
  self: Vec3,
) =
  self[1]
template `y=`*(
  self: Vec3,
  val: untyped
) =
  self[1] = val

template `z`*(
  self: Vec3,
) =
  self[2]
template `z=`*(
  self: Vec3,
  val: untyped
) =
  self[2] = val


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


proc `dot`*[T](
  left: Vec3[T],
  right: Vec3[T],
): T = 
  result = T(0)
  for i in 0 .. result.v.len():
    result = result + (left.v[i] * right.v[i])
  #T(
  #  (
  #    left.x * right.x
  #  ) + (
  #    left.y * right.y 
  #  ) + (
  #    left.z * right.z
  #  )
  #)


