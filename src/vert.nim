import std/macros
import fixedPt
import vec4
import vec3
import vec2

type
  Vert* = object
    v*: Vec4[MyFixed]
    uv*: Vec2[MyFixedUv]

template `v2`*(
  self: Vert,
): Vec2[MyFixed] =
  Vec2[MyFixed](
    v: [
      self.v.x,
      self.v.y,
    ]
  )
