import std/macros
import vec3

macro `mat3x3Size2dX`*(): untyped =
  result = quote do:
    3
macro `mat3x3Size2dY`*(): untyped =
  result = quote do:
    3

type
  Mat3x3*[T] = object
    m: array[
      mat3x3Size2dY,
      array[mat3x3Size2dX, T],
    ]

proc `plus`*[T](
  left: Mat3x3[T],
  right: Mat3x3[T],
): Mat3x3[T] =
  var ret: Mat3x3[T];
  for j in 0 ..< mat3x3Size2dY:
    for i in 0 ..< mat3x3Size2dX:
      ret.m[j][i] = (
        left.m[j][i] + right.m[j][i]
      )
  return ret;

template `+`*(
  left: Mat3x3,
  right: Mat3x3,
): untyped =
  left.plus right

proc `minus`*[T](
  left: Mat3x3[T],
  right: Mat3x3[T],
): Mat3x3[T] =
  var ret: Mat3x3[T];
  for j in 0 ..< mat3x3Size2dY:
    for i in 0 ..< mat3x3Size2dX:
      ret.m[j][i] = (
        left.m[j][i] - right.m[j][i]
      )
  return ret;

template `-`*(
  left: Mat3x3,
  right: Mat3x3,
): untyped =
  left.minus right

proc `star`*[T](
  left: Mat3x3[T],
  right: T,
): Mat3x3[T] =
  var ret: Mat3x3[T];
  for j in 0 ..< mat3x3Size2dY:
    for i in 0 ..< mat3x3Size2dX:
      ret.m[j][i] = (
        left.m[j][i] - right
      )
  return ret;

template `*`*(
  left: Mat3x3,
  right: untyped,
): untyped =
  left.star right

proc `star`*[T](
  left: Mat3x3[T],
  right: Mat3x3[T],
): Mat3x3[T] =
  var ret: Mat3x3[T];
  for j in 0 ..< mat3x3Size2dY:
    for i in 0 ..< mat3x3Size2dX:
      #T sum = T();
      var sum: T
      sum.setFromInt(0)
      for k in 0 ..< mat3x3Size2dX:
        let temp_sum = left.m[j][k] * right.m[k][i];
        sum = sum + temp_sum;
      ret.m[j][i] = sum;
  return ret;

template `*`*(
  left: Mat3x3,
  right: Mat3x3,
): untyped =
  left.star right

proc `transpose`*[T](
  self: Mat3x3[T],
): Mat3x3[T] =
  var ret: Mat3x3[T];
  for j in 0 ..< mat3x3Size2dY:
    for i in 0 ..< mat3x3Size2dX:
      ret.m[j][i] = self.m[i][j];
  return ret;

proc `star`*[T](
  left: Mat3x3[T],
  right: Vec3[T]
): Vec3[T] = 
  var temp: T
  var ret = Vec3[T](
    #x: temp.setFromInt(0),
    #y: temp.setFromInt(0),
    #z: temp.setFromInt(0),
    v: [
      temp.setFromInt(0),
      temp.setFromInt(0),
      temp.setFromInt(0),
    ]
  )

  for y in 0 ..< mat3x3Size2dY:
    var sum = temp.setFromInt(0)
    for x in 0 ..< mat3x3Size2dX:
      sum = sum + left.m[y][x] * right.v[x];
    ret.v[y] = sum;

  return ret;
template `*`*(
  left: Mat3x3,
  right: Vec3,
): untyped =
  left.star right

proc `mkMat3x3Identity`*[T](): Mat3x3[T] = 
  var temp: T
  let zero = temp.setFromInt(0)
  let one = temp.setFromInt(1)
  let ret = Mat3x3[T](
    m: [
      [one, zero, zero],
      [zero, one, zero],
      [zero, zero, one],
    ]
  )
  return ret
