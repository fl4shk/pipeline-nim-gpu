import nimToPipelineCSrc/nimToPipelineC
# adapted into PipelineC-capable code from
# https://github.com/chmike/fpsqrt/blob/master/fpsqrt.c#L69
#proc `sqrtI128`*(
#  v: int128
#): int128 =
#  result = int128(3)

proc `sqrtI64`*(
  v: int64
): int64 {.cnomangle.} =
  var b: uint64 = (
    uint64(1) shl 62
  )
  var q: uint64 = 0
  var r: uint64 = uint64(v)

  for i in 0 ..< 32:
    var t: uint64 = q + b
    q = q shr 1
    if r >= t:
      r = r - t
      q = q + b
    b = b shr 2
  let ret = int64(q)
  result = ret

#proc `sqrtI64`*(
#  v: int32
#): int32 {.cnomangle.} =
#  result = int32(sqrtI64(int64(v)))
