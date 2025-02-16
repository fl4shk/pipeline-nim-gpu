import std/macros
import vec4
import vec3
import mat3x3

macro `mat4x4Size2dX`*(): untyped =
  result = quote do:
    4
macro `mat4x4Size2dY`*(): untyped =
  result = quote do:
    4


type
  Mat4x4*[T] = object
    m: array[
      mat4x4Size2dY,
      array[mat4x4Size2dX, T],
    ]

proc `plus`*[T](
  left: Mat4x4[T],
  right: Mat4x4[T],
): Mat4x4[T] =
  var ret: Mat4x4[T];
  for j in 0 ..< mat4x4Size2dY:
    for i in 0 ..< mat4x4Size2dX:
      ret.m[j][i] = (
        left.m[j][i] + right.m[j][i]
      )
  return ret;

template `+`*(
  left: Mat4x4,
  right: Mat4x4,
): untyped =
  left.plus right

proc `minus`*[T](
  left: Mat4x4[T],
  right: Mat4x4[T],
): Mat4x4[T] =
  var ret: Mat4x4[T];
  for j in 0 ..< mat4x4Size2dY:
    for i in 0 ..< mat4x4Size2dX:
      ret.m[j][i] = (
        left.m[j][i] - right.m[j][i]
      )
  return ret;

template `-`*(
  left: Mat4x4,
  right: Mat4x4,
): untyped =
  left.minus right

proc `star`*[T](
  left: Mat4x4[T],
  right: T,
): Mat4x4[T] =
  var ret: Mat4x4[T];
  for j in 0 ..< mat4x4Size2dY:
    for i in 0 ..< mat4x4Size2dX:
      ret.m[j][i] = (
        left.m[j][i] - right
      )
  return ret;

template `*`*(
  left: Mat4x4,
  right: untyped,
): untyped =
  left.star right

proc `star`*[T](
  left: Mat4x4[T],
  right: Mat4x4[T],
): Mat4x4[T] =
  var ret: Mat4x4[T];
  for j in 0 ..< mat4x4Size2dY:
    for i in 0 ..< mat4x4Size2dX:
      #T sum = T();
      var sum: T
      sum.setFromInt(0)
      for k in 0 ..< mat4x4Size2dX:
        let temp_sum = left.m[j][k] * right.m[k][i];
        sum = sum + temp_sum;
      ret.m[j][i] = sum;
  return ret;

template `*`*(
  left: Mat4x4,
  right: Mat4x4,
): untyped =
  left.star right

proc `transpose`*[T](
  self: Mat4x4[T],
): Mat4x4[T] =
  var ret: Mat4x4[T];
  for j in 0 ..< mat4x4Size2dY:
    for i in 0 ..< mat4x4Size2dX:
      ret.m[j][i] = self.m[i][j];
  return ret;

proc `star`*[T](
  left: Mat4x4[T],
  right: Vec4[T]
): Vec4[T] = 
  var temp: T
  var ret = Vec4[T](
    v: [
      temp.setFromInt(0),
      temp.setFromInt(0),
      temp.setFromInt(0),
      temp.setFromInt(0),
    ]
    #x: temp.setFromInt(0),
    #y: temp.setFromInt(0),
    #z: temp.setFromInt(0),
  )

  for y in 0 ..< mat4x4Size2dY:
    var sum = temp.setFromInt(0)
    for x in 0 ..< mat4x4Size2dX:
      sum = sum + left.m[y][x] * right.v[x];
    ret.v[y] = sum;

  return ret;
template `*`*(
  left: Mat4x4,
  right: Vec4,
): untyped =
  left.star right

proc `multH`*[T](
  left: Mat4x4[T],
  v: Vec4[T],
): Vec4[T] =
  var ret: Vec4[T]
  #let m = left.m
  let a: T = (
    (
      v.x * left.m[0][0]
    ) + (
      v.y * left.m[0][1]
    ) + (
      v.z * left.m[0][2]
    ) + (
      left.m[0][3]
    )
  )
  let b: T = (
    (
      v.x * left.m[1][0]
    ) + (
      v.y * left.m[1][1]
    ) + (
      v.z * left.m[1][2]
    ) + (
      left.m[1][3]
    )
  )
  let c: T = (
    (
      v.x * left.m[2][0]
    ) + (
      v.y * left.m[2][1]
    ) + (
      v.z * left.m[2][2]
    ) + (
      left.m[2][3]
    )
  )
  let w: T = (
    (
      v.x * left.m[3][0]
    ) + (
      v.y * left.m[3][1]
    ) + (
      v.z * left.m[3][2]
    ) + (
      left.m[3][3]
    )
  )
  ret.x = a / w;
  ret.y = b / w;
  ret.z = c / w;
  ret.w = w;
  return ret

proc `setTranslate`*[T](
  self: Mat4x4[T],
  v: Vec3[T],
  rightVecMult: bool=true
): Mat4x4[T] =
  var ret: Mat4x4[T]
  for k in 0 ..< v.v.len():
    if rightVecMult:
      ret.m[k][3] = v[k]
    else:
      ret.m[3][k] = v[k]
  return ret

proc `setRotScale`*[T](
  self: Mat4x4[T],
  m3x3: Mat3x3[T],
  rightVecMult: bool=true
): Mat4x4[T] =
  var ret: Mat4x4[T]
  for j in 0 ..< m3x3.m.len():
    for i in 0 ..< m3x3.m[j].len():
      if rightVecMult:
        ret.m[j][i] = m3x3.m[j][i];
      else:
        # use the transpose
        ret.m[j][i] = m3x3.m[i][j];
  return ret
#--------
proc `inverse`*[T](
  self: Mat4x4[T],
): Mat4x4[T] =
  let m = self.m
  let A2323 = m[2][2] * m[3][3] - m[2][3] * m[3][2];
  let A1323 = m[2][1] * m[3][3] - m[2][3] * m[3][1];
  let A1223 = m[2][1] * m[3][2] - m[2][2] * m[3][1];
  let A0323 = m[2][0] * m[3][3] - m[2][3] * m[3][0];
  let A0223 = m[2][0] * m[3][2] - m[2][2] * m[3][0];
  let A0123 = m[2][0] * m[3][1] - m[2][1] * m[3][0];
  let A2313 = m[1][2] * m[3][3] - m[1][3] * m[3][2];
  let A1313 = m[1][1] * m[3][3] - m[1][3] * m[3][1];
  let A1213 = m[1][1] * m[3][2] - m[1][2] * m[3][1];
  let A2312 = m[1][2] * m[2][3] - m[1][3] * m[2][2];
  let A1312 = m[1][1] * m[2][3] - m[1][3] * m[2][1];
  let A1212 = m[1][1] * m[2][2] - m[1][2] * m[2][1];
  let A0313 = m[1][0] * m[3][3] - m[1][3] * m[3][0];
  let A0213 = m[1][0] * m[3][2] - m[1][2] * m[3][0];
  let A0312 = m[1][0] * m[2][3] - m[1][3] * m[2][0];
  let A0212 = m[1][0] * m[2][2] - m[1][2] * m[2][0];
  let A0113 = m[1][0] * m[3][1] - m[1][1] * m[3][0];
  let A0112 = m[1][0] * m[2][1] - m[1][1] * m[2][0];

  var temp: T
  let invDet = (
    (
      temp.setFromInt(1)
    ) / (
      (
        (
          m[0][0]
        ) * (
          m[1][1] * A2323 - m[1][2] * A1323 + m[1][3] * A1223 
        )
      ) - (
        (
          m[0][1]
        ) * (
          m[1][0] * A2323 - m[1][2] * A0323 + m[1][3] * A0223 
        ) 
      ) + (
        (
          m[0][2]
        ) * (
          m[1][0] * A1323 - m[1][1] * A0323 + m[1][3] * A0123
        ) 
      ) - (
        (
          m[0][3]
        ) * (
          m[1][0] * A1223 - m[1][1] * A0223 + m[1][2] * A0123 
        )
      )
    )
  )

  #Mat4x4 ret
  var ret: Mat4x4[T]
  ret.m[0][0] = (
    (
      invDet
    ) * (
      m[1][1] * A2323 - m[1][2] * A1323 + m[1][3] * A1223
    )
  )
  ret.m[0][1] = (
    (
      invDet
    ) * (
      -(m[0][1] * A2323 - m[0][2] * A1323 + m[0][3] * A1223)
    )
  )
  ret.m[0][2] = (
    (
      invDet
    ) * (
      (m[0][1] * A2313 - m[0][2] * A1313 + m[0][3] * A1213)
    )
  )
  ret.m[0][3] = (
    (
      invDet
    ) * (
      (m[0][1] * A2312 - m[0][2] * A1312 + m[0][3] * A1212)
    )
  )
  ret.m[1][0] = (
    (
      invDet
    ) * (
      (m[1][0] * A2323 - m[1][2] * A0323 + m[1][3] * A0223)
    )
  )
  ret.m[1][1] = (
    (
      invDet
    ) * (
      (m[0][0] * A2323 - m[0][2] * A0323 + m[0][3] * A0223)
    )
  )
  ret.m[1][2] = (
    (
      invDet
    ) * (
      (m[0][0] * A2313 - m[0][2] * A0313 + m[0][3] * A0213)
    )
  )
  ret.m[1][3] = (
    (
      invDet
    ) * (
      (m[0][0] * A2312 - m[0][2] * A0312 + m[0][3] * A0212)
    )
  )
  ret.m[2][0] = (
    (
      invDet
    ) * (
      (m[1][0] * A1323 - m[1][1] * A0323 + m[1][3] * A0123)
    )
  )
  ret.m[2][1] = (
    (
      invDet
    ) * (
      (m[0][0] * A1323 - m[0][1] * A0323 + m[0][3] * A0123)
    )
  )
  ret.m[2][2] = (
    (
      invDet
    ) * (
      (m[0][0] * A1313 - m[0][1] * A0313 + m[0][3] * A0113)
    )
  )
  ret.m[2][3] = (
    (
      invDet
    ) * (
      (m[0][0] * A1312 - m[0][1] * A0312 + m[0][3] * A0112)
    )
  )
  ret.m[3][0] = (
    (
      invDet
    ) * (
      (m[1][0] * A1223 - m[1][1] * A0223 + m[1][2] * A0123)
    )
  )
  ret.m[3][1] = (
    (
      invDet
    ) * (
      (m[0][0] * A1223 - m[0][1] * A0223 + m[0][2] * A0123)
    )
  )
  ret.m[3][2] = (
    (
      invDet
    ) * (
      (m[0][0] * A1213 - m[0][1] * A0213 + m[0][2] * A0113)
    )
  )
  ret.m[3][3] = (
    (
      invDet
    ) * (
      (m[0][0] * A1212 - m[0][1] * A0212 + m[0][2] * A0112)
    )
  )
  return ret
#--------

proc `mkMat4x4Identity`*[T](): Mat4x4[T] = 
  var temp: T
  let zero = temp.setFromInt(0)
  let one = temp.setFromInt(1)
  let ret = Mat4x4[T](
    m: [
      [one, zero, zero, zero],
      [zero, one, zero, zero],
      [zero, zero, one, zero],
      [zero, zero, zero, one],
    ]
  )
  return ret
