import std/strutils
#import std/sequtils
import std/algorithm
import std/deques
import std/tables
#import std/cmdline
import std/math
import miscMath
import mode
import std/sets
import std/options

proc reversed*[T](
  that: seq[T]
): seq[T] =
  var i: int = that.len() - 1
  while i >= 0:
    result.add that[i]
    i -= 1
#proc swap*[T](
#  left: var T,
#  right: ptr T,
#) =
#  var temp = left
#  left = right
#  right = temp

const
  triVertArrLen* = 3
  quadVertArrLen* = 4
  cubeNumVerts* = 8
  #cubeOrderTriA2dLen* = 2
  #cubeOrderTriArrLen* = 3
  #cubeTriArrLen* = 2

type
  Triple*[T] = object
    v*: array[3, T]

proc nonSqrtDist*[T](
  left: Triple[T],
  right: Triple[T]
): float64 =
  result = 0.0
  for i in 0 ..< left.v.len():
    let temp = float64(left.v[i]) - float64(right.v[i])
    result += temp * temp
proc dist*[T](
  left: Triple[T],
  right: Triple[T],
): float64 =
  #var ret: float64 = 0.0
  result = sqrt(nonSqrtDist(left=left, right=right))
  #result = T(ret)

proc `-`*(
  left: Triple,
  right: Triple,
): Triple =
  for i in 0 ..< left.v.len():
    result.v[i] = left.v[i] - right.v[i]

proc `==`*(
  left: Triple,
  right: Triple,
): bool =
  for i in 0 ..< left.v.len():
    if left.v[i] != right.v[i]:
      return false
  return true
proc `!=`*(
  left: Triple,
  right: Triple,
): bool =
  return not (left == right)

proc `>`*(
  left: Triple,
  right: Triple,
): bool =
  #for i in 0 ..< left.v.len():
  #result = left.v > right.v
  for i in 0 ..< left.v.len():
    if left.v[i] > right.v[i]:
      return true
    elif left.v[i] == right.v[i]:
      discard
    else:
      return false
  return false # they were equal

  #if left.v[0] > right.v[0]:
  #  return true
  #elif left.v[0] == right.v[0]:
  #  if left.v[1] > right.v[1]:
  #    return
  #else:
  #  return false
proc `<`*(
  left: Triple,
  right: Triple,
): bool =
  for i in 0 ..< left.v.len():
    if left.v[i] < right.v[i]:
      return true
    elif left.v[i] == right.v[i]:
      discard
    else:
      return false
  return false # they were equal

proc myQuadCmp(
  left: array[quadVertArrLen, Triple[int32]],
  right: array[quadVertArrLen, Triple[int32]],
): int =
  #if left[0] < right[0]:
  #  return -1
  #elif left[0] == right[0]:
  #  return 0
  #else:
  #  return 1
  for i in 0 ..< left.len():
    if left[i] < right[i]:
      return -1
    elif left[i] == right[i]:
      discard
    else:
      return 1
  return 0 # they were equal

#proc `<`*(
#  left: array[quadVertArrLen, Triple[int32]],
#  right: array[quadVertArrLen, Triple[int32]],
#): bool =
#  result = (left[0] < right[0])
#  #for i in 0 ..< left.len():
#  #  if left[i] < right[i]:
#  #    return true
#  #  elif left[i] == right[i]:
#  #    discard
#  #  else:
#  #    return false
#  #return false # they were equal



#type
#  VertUv = object
#    u*: float64
#    v*: float64

#type
#  HalfQuad = object
#    h: array[2, uint]


#type
#  FaceElem = object
#    vIdx*: uint
#    vtIdx*: uint
#    vnIdx*: uint
type
  FaceIdx* = enum
    fidxV,
    fidxVt,
    fidxVn,
    fidxLim,

#type
#  SideIdx* = enum
#    sidxLeft,
#    sidxRight,
#    sidxBottom
#    sidxTop,
#    sidxLim,
const
  sidxLim: uint = 4

type
  CubeIdx* = enum
    cidxFront,
    cidxBack,
    cidxLeft,
    cidxRight,
    cidxBottom,
    cidxTop,
    cidxLim,
proc revCubeIdx(
  cidx: CubeIdx
): CubeIdx =
  result = cidxLim
  case cidx:
  of cidxFront:
    result = cidxBack
  of cidxBack:
    result = cidxFront
  of cidxLeft:
    result = cidxRight
  of cidxRight:
    result = cidxLeft
  of cidxBottom:
    result = cidxTop
  of cidxTop:
    result = cidxBottom
  else:
    doAssert(false)
const
  revCubeIdxArr: array[cidxLim, CubeIdx] = [
    cidxBack, # cidxFront:
    cidxFront, # cidxBack
    cidxRight, # cidxLeft
    cidxLeft, # cidxRight
    cidxTop, # cidxBottom
    cidxBottom, # cidxTop
  ]

type
  ReducedCubeIdx* = enum
    rcidxFront,
    rcidxLeft,
    rcidxBottom,
    rcidxLim,

type
  LimitIdx* = enum
    lidxMin,
    lidxMax,
    lidxLim,

#type
#  CubeFace* = object
#    #valid*: bool
#    cnIdx*: uint # CubeUnit index



#proc quadVertCmp(
#  x: array[quadVertArrLen, Triple[int32]],
#  y: array[quadVertArrLen, Triple[int32]],
#): int =
#  const
#    myLen = quadVertArrLen * x[0].v.len()
#  var tempX: seq[myLen, int32]
#  var tempY: seq[myLen, int32]
#
#  #let tempX = [
#  #  x[0].v[0], x[0].v[1], x[0].v[2],
#  #  #x[1].v[0], x[1].v[1], x[1].v[2],
#  #  #x[2].v[0], x[2].v[1], x[2].v[2],
#  #  #x[3].v[0], x[3].v[1], x[3].v[2],
#  #]
#  #let tempY = [
#  #  y[0].v[0], y[0].v[1], y[0].v[2],
#  #  #y[1].v[0], y[1].v[1], y[1].v[2],
#  #  #y[2].v[0], y[2].v[1], y[2].v[2],
#  #  #y[3].v[0], y[3].v[1], y[3].v[2],
#  #]
#  result = cmp(openarray(tempX), openarray(tempY))

type
  Cube* = object
    #c*: array[8, (bool, Triple[int32])]
    c*: array[cubeNumVerts, Triple[int32]]
    #c*: array[rcidxLim, seq[CubeFace]] # index into the face array
    #vtIdx*: uint #float64
    #normSeq*: seq[uint]
#type
#  ReducedCube* = object
#    c*: array[rcidxLim, CubeFace]

type
  CubeUnit* = object
    # `vArr`: plain old vertices (of a single quad)
    vArr*: array[quadVertArrLen, Triple[int32]]
    rcidx*: Option[ReducedCubeIdx]
    cidx*: Option[CubeIdx]
    # `n`: normalized version of `vArr`; used to determine face orientation
    n*: array[quadVertArrLen, Triple[int32]]
    # `fIdx`: index into `ObjConvert.fSortSeq`
    fIdx*: int
var vnConvArr: array[rcidxLim, array[2, uint]]

#proc coplFromCidxToCheckAdj(
#  cidx: CubeIdx
#): array[cidxLim, bool] =
#  result = [
#    true, # cidxFront
#    true, # cidxBack
#    true, # cidxLeft
#    true, # cidxRight
#    true, # cidxBottom
#    true, # cidxTop
#  ]
#  result[revCubeIdxArr[cidx]] = false

proc toVnIdx(
  cidx: CubeIdx
): uint =
  case cidx:
  of cidxFront:
    result = vnConvArr[rcidxFront][0]
  of cidxBack:
    result = vnConvArr[rcidxFront][1]
  of cidxLeft:
    result = vnConvArr[rcidxLeft][0]
  of cidxRight:
    result = vnConvArr[rcidxLeft][1]
  of cidxBottom:
    result = vnConvArr[rcidxBottom][0]
  of cidxTop:
    result = vnConvArr[rcidxBottom][1]
  else:
    result = 0

proc isAdjSide(
  left: var CubeUnit,
  right: var CubeUnit,
): bool =
  # This function checks only if all vertices of the particular quad
  # (represented by the two `CubeUnit`s) are the same.
  let vLeftSet = toHashSet(left.vArr)
  let vRightSet = toHashSet(right.vArr)
  result = (vLeftSet == vRightSet)

const
  #coplRcidxVidxArr: array[rcidxLim, uint] = [
  #  1, # rcidxFront: y changes if not coplanar
  #  0, # rcidxLeft: x changes if not coplanar
  #  2, # rcidxBottom: z changes if not coplanar
  #]
  #coplCidxVidxArr: array[cidxLim, uint] = [
  #  1, # cidxFront: y changes if not coplanar
  #  1, # cidxBack: y changes if not coplanar
  #  0, # cidxLeft: x changes if not coplanar
  #  0, # cidxRight: x changes if not coplanar
  #  2, # cidxBottom: z changes if not coplanar
  #  2, # cidxTop: z changes if not coplanar
  #]
  #coplCidxVidxA2d: array[cidxLim, array[3, uint]] = [
  #  [0, 2, 1], # cidxFront: y changes if not coplanar
  #  [0, 2, 1], # cidxBack: y changes if not coplanar
  #  [1, 2, 0], # cidxLeft: x changes if not coplanar
  #  [1, 2, 0], # cidxRight: x changes if not coplanar
  #  [0, 1, 2], # cidxBottom: z changes if not coplanar
  #  [0, 1, 2], # cidxTop: z changes if not coplanar
  #]
  coplRcidxVidxArr: array[rcidxLim, uint] = [
    2, # rcidxFront: y changes if not coplanar
    0, # rcidxLeft: x changes if not coplanar
    1, # rcidxBottom: z changes if not coplanar
  ]
  #coplCidxVidxArr: array[cidxLim, uint] = [
  #  2, # cidxFront: y changes if not coplanar
  #  2, # cidxBack: y changes if not coplanar
  #  0, # cidxLeft: x changes if not coplanar
  #  0, # cidxRight: x changes if not coplanar
  #  1, # cidxBottom: z changes if not coplanar
  #  1, # cidxTop: z changes if not coplanar
  #]
  coplCidxVidxA2d: array[cidxLim, array[3, uint]] = [
    [1, 0, 2], # cidxFront: y changes if not coplanar
    [1, 0, 2], # cidxBack: y changes if not coplanar
    [2, 1, 0], # cidxLeft: x changes if not coplanar
    [2, 1, 0], # cidxRight: x changes if not coplanar
    [2, 0, 1], # cidxBottom: z changes if not coplanar
    [2, 0, 1], # cidxTop: z changes if not coplanar
  ]

proc fastIsCoplanar(
  left: var CubeUnit,
  right: var CubeUnit,
): bool =
  doAssert(left.rcidx.isSome())
  doAssert(right.rcidx.isSome())
  let myIdx = coplRcidxVidxArr[left.rcidx.get()]
  #echo "rcidx's: " & $left.rcidx.get() & " " & $right.rcidx.get()
  #echo "myIdx: " & $myIdx
  #echo "left:" & $left.vArr
  #echo "right:" & $right.vArr
  for idx in 0 ..< quadVertArrLen:
    var cond: bool = true

    cond = (left.vArr[idx].v[myIdx] == right.vArr[idx].v[myIdx])

    #echo "debug test:"
    #echo left.vArr[idx].v[myIdx]
    #echo right.vArr[idx].v[myIdx]
    #echo cond
    if cond and left.vArr[0].v[myIdx] != left.vArr[idx].v[myIdx]:
      cond = false
    ##echo cond
    #if cond and right.vArr[0].v[myIdx] != right.vArr[idx].v[myIdx]:
    #  cond = false
    ##echo cond
    #if cond and left.vArr[0].v[myIdx] != right.vArr[0].v[myIdx]:
    #  cond = false
    ##echo cond
    ##echo ""

    #echo (
    #  $idx & " " & $cond & ": " & $left.vArr[idx] & " " & $right.vArr[idx]
    #)

    #if cond:
    #  result = false
    if not cond:
      #echo "returning false"
      #echo "rcidx's: " & $left.rcidx.get() & " " & $right.rcidx.get()
      return false
  #echo "returning true"
  #echo "rcidx's: " & $left.rcidx.get() & " " & $right.rcidx.get()
  return true
    
  #return (
  #  left.vArr[0].v[myIdx] == right.vArr[0].v[myIdx]
  #)

#proc isCoplanarEtc(
#  left: var CubeUnit,
#  right: var CubeUnit,
#  #cidx: CubeIdx
#): bool =
#  #if not (left.cidx.isSome() and right.cidx.isSome()):
#  #  return false
#
#  #doAssert(left.cidx.isSome())
#  #doAssert(right.cidx.isSome())
#  #doAssert(left.rcidx.isSome())
#  #doAssert(right.rcidx.isSome())
#  if not (
#    #(
#    #  left.cidx.isSome()
#    #) and (
#    #  right.cidx.isSome()
#    #) 
#    #and
#    (
#      left.rcidx.isSome()
#    ) and (
#      right.rcidx.isSome()
#    )
#  ):
#    #echo "returning false!"
#    #echo $left.rcidx.isSome() & " " & $right.rcidx.isSome()
#    return false
#  #echo "maybe not returning false!"
#
#  if left.rcidx.get() != right.rcidx.get():
#    return false
#  else:
#    return fastIsCoplanar(left=left, right=right)
#
#  #case left.rcidx.get():
#  #of rcidxFront:
#  #  return (left.vArr[0].v[1] == right.vArr[0].v[1])
#  #of rcidxLeft:
#  #  # 
#  #  return (left.vArr[0].v[0] == right.vArr[0].v[0])
#  #of rcidxBottom:
#  #  # 
#  #  return (left.vArr[0].v[2] == right.vArr[0].v[2])
#  #else:
#  #  doAssert(false)

proc hasSharedVertPair*(
  left: ptr CubeUnit,
  right: ptr CubeUnit,
): bool =
  result = false
  for j in 0 ..< left.vArr.len():
    for i in 0 ..< right.vArr.len():
      let la = left.vArr[(j + 0) mod left.vArr.len()]
      let lb = left.vArr[(j + 1) mod left.vArr.len()]
      let ra = right.vArr[(i + 0) mod left.vArr.len()]
      let rb = right.vArr[(i + 1) mod left.vArr.len()]
      if (
        (
          (la == ra) and (lb == rb)
        ) or (
          (lb == ra) and (lb == ra)
        )
      ):
        result = true

type
  CubeOrder* = object
    c*: array[quadVertArrLen, Triple[int32]]
    #t*: array[
    #  cubeOrderTriA2dLen,
    #  array[cubeOrderTriArrLen, Triple[uint]]
    #]

const
  #cubeOrderTriIdxArr*: array[
  #  cubeTriArrLen, Triple[uint]
  #] = [
  #  Triple[uint](v: [0, 1, 2]),
  #  Triple[uint](v: [1, 2, 3]),
  #]
  cubeOrderA2d*: array[cidxLim, CubeOrder] = [
    # cidxFront
    CubeOrder(
      c: [
        Triple[int32](v: [0, 0, 0]),
        Triple[int32](v: [0, 1, 0]),
        Triple[int32](v: [1, 1, 0]),
        Triple[int32](v: [1, 0, 0]),
      ],
      #t: [
      #],
    ),

    # cidxBack
    CubeOrder(
      c: [
        Triple[int32](v: [0, 0, 1]),
        Triple[int32](v: [0, 1, 1]),
        Triple[int32](v: [1, 1, 1]),
        Triple[int32](v: [1, 0, 1]),
      ],
      #t: [
      #],
    ),

    # cidxLeft
    CubeOrder(
      c: [
        Triple[int32](v: [0, 0, 0]),
        Triple[int32](v: [0, 0, 1]),
        Triple[int32](v: [0, 1, 1]),
        Triple[int32](v: [0, 1, 0]),
      ],
      #t: [
      #],
    ),

    # cidxRight
    CubeOrder(
      c: [
        Triple[int32](v: [1, 0, 0]),
        Triple[int32](v: [1, 0, 1]),
        Triple[int32](v: [1, 1, 1]),
        Triple[int32](v: [1, 1, 0]),
      ],
      #t: [
      #],
    ),

    # cidxBottom
    CubeOrder(
      c: [
        Triple[int32](v: [0, 0, 0]),
        Triple[int32](v: [0, 0, 1]),
        Triple[int32](v: [1, 0, 1]),
        Triple[int32](v: [1, 0, 0]),
      ],
      #t: [
      #],
    ),

    # cidxTop
    CubeOrder(
      c: [
        Triple[int32](v: [0, 1, 0]),
        Triple[int32](v: [0, 1, 1]),
        Triple[int32](v: [1, 1, 1]),
        Triple[int32](v: [1, 1, 0]),
      ],
      #t: [
      #],
    ),
  ]

#proc isFull*(
#  self: Cube
#): bool =
#  for c in self.c:
#    if c.len() != 2:
#      return false
#    #for item in c:
#    #  if not item.valid:
#    #    return false
#  return true

#proc reorder(
#  inp: Cube
#): Cube =
type
  CubeDataInfo* = object
    # `unitIdx`: index into `ObjConvert.cUnitSeq`
    unitIdx*: uint
    cidx*: Option[CubeIdx]

type
  CubeData* = object
    # `c`: the `Cube` itself
    c*: Cube
    cUnitIdxSeq*: seq[uint]
    # `cInfoArr`: an array containing each side's own `CubeDataInfo`
    cInfoArr*: array[cidxLim, CubeDataInfo]
#type
#  CubeDataOpt* = object
#    cData*: CubeData

#type
#  CubeSideIdx* = enum
#    csidx,
#    csidxLim,

#type
#  CubeSide* = object
#    cidx*: CubeIdx
#    #vArr*: array[quadVertArrLen, Triple[int32]]
#    #cOrder*: ptr proc(cData: CubeData, cidx: CubeIdx)
#    cOrder*: CubeOrder


proc toCubeDataInfoArr(
  cUnitSeq: ptr seq[CubeUnit],
  cData: ptr CubeData,
): array[cidxLim, CubeDataInfo] =
  var myRciTbl: Table[
    ReducedCubeIdx, seq[CubeDataInfo]
  ]
  for unitIdx in cData.cUnitIdxSeq:
    let cUnit: ptr CubeUnit = addr cUnitSeq[unitIdx]
    #echo "unit[]: " & $unit[]
    var myInpCidx: CubeIdx
    doAssert(
      cUnit.rcidx.isSome
    )
    case cUnit.rcidx.get():
    of rcidxFront:
      myInpCidx = cidxFront
    of rcidxLeft:
      myInpCidx = cidxLeft
    of rcidxBottom:
      myInpCidx = cidxBottom
    else:
      doAssert(false)

    if cUnit.rcidx.get() notin myRciTbl:
      myRciTbl[cUnit.rcidx.get()] = @[CubeDataInfo(
        unitIdx: unitIdx,
        cidx: some(myInpCidx),
      )]
    else:
      let mySeq = addr myRciTbl[cUnit.rcidx.get()]
      if mySeq[].len() == 1:
      #for i in 0 ..< mySeq[].len():
        let info = mySeq[0]
        let otherUnit = addr cUnitSeq[info.unitIdx]
        var vSub: array[quadVertArrLen, Triple[int32]]
        #var mySum: int32 = 0
        var haveNeg: bool = false
        for i in 0 ..< vSub.len():
          vSub[i] = cUnit.vArr[i] - otherUnit.vArr[i]

        if (
          (
            not vSub[0].v.contains(1)
          ) and (
            not vSub[0].v.contains(-1)
          )
        ):
          #var s: string
          #s.add "continuing: \n"
          #s.add $unit.vArr & " \n"
          #s.add "- " & $otherUnit.vArr & " \n"
          #s.add "  ->" & $vSub & "\n"
          #s.add "1:" & $vSub[0].v.contains(1)
          #s.add "  "
          #s.add "-1:" & $vSub[0].v.contains(-1)
          #echo s
          continue

        if vSub[0].v.contains(-1): # they should all be identical
          haveNeg = true
        var myCidx: array[2, CubeIdx]

        case cUnit.rcidx.get():
        of rcidxFront:
          myCidx = [cidxFront, cidxBack]
        of rcidxLeft:
          myCidx = [cidxLeft, cidxRight]
        of rcidxBottom:
          myCidx = [cidxBottom, cidxTop]
        else:
          doAssert(false)
        var toAdd = CubeDataInfo(
          unitIdx: unitIdx,
          cidx: some(myCidx[1]),
        )
        mySeq[].add(
          toAdd
          #(unitIdx, true)
        )
        #echo haveNeg
        if not haveNeg:
          swap(mySeq[0].unitIdx, mySeq[1].unitIdx)

        #for i in 0 ..< mySeq[].len():
        #  echo mySeq[i]

        ##echo ""

        #var s: string
        ##s.add $unit.rcidx & ":\n"
        #s.add $myCidx & ":\n"
        #for i in 0 ..< mySeq[].len():
        #  let tempUnit = addr cUnitSeq[mySeq[i].unitIdx]
        #  if i == 0:
        #    vSub = tempUnit.vArr
        #    s.add $tempUnit.vArr & "\n"
        #  elif i == 1:
        #    for k in 0 ..< vSub.len():
        #      vSub[k] = vSub[k] - tempUnit.vArr[k]
        #    s.add "- " & $tempUnit.vArr & "\n"
        #  else:
        #    doAssert(false)

        ##s.add $unit.vArr & "\n"
        ##s.add "- " & $otherUnit.vArr & "\n"
        #s.add "  -> " & $vSub & "\n"
        #echo s
  for k, v in myRciTbl:
    #echo k
    for item in v:
      #echo item
      #doAssert(
      #  item.cidx.isSome
      #)
      if item.cidx.isSome:
        result[item.cidx.get()] = item
    #echo "--"
  #for cidx in CubeIdx(0) ..< cidxLim:
  #  if not result[cidx].cidx.isSome:
  #    echo cidx
  #    echo result
  #  doAssert(
  #    result[cidx].cidx.isSome
  #  )

  #echo "----"

  #var vSet = toHashSet(cUnit.n)

  #for cidx in CubeIdx(0) ..< cidxLim:
  #  #var vSet = toHashSet(vArr)
  #  let cOrder = addr cubeOrderA2d[cidx]
  #  var cOrderSet = toHashSet(cOrder.c)
  #  if cOrderSet == vSet:
  #    return cidx
  #doAssert(
  #  false
  #)

  #return cidxLim
    #var cOrder: CubeOrder
  #let cOrder = addr cubeOrderA2d[cidx]
  #for i in 0 ..< quadVertArrLen:
  #  let myTriple = cOrder.c[i]
  #  let x = myTriple.v[0]
  #  let y = myTriple.v[1]
  #  let z = myTriple.v[2]
  #  let tempIdx = (x * 2 * 2) + (y * 2) + z
  #result[1] =

type
  # `RectCoplMain`:
  #   a single coplanar region and its rectangles
  RectCoplMain = object
    ## `cDataIdxSet`:
    ##   For the particular coplanar region, this is its set of indices
    ##   into `ObjConvert.cDataOptS2d[^1]` or `ObjConvert.cDataAdjS2d[^1]`
    #cDataIdxSet*: HashSet[uint]

    # `rBoundsRect`:
    #   The bounding rect of the particular coplanar region.
    #   In the general case, this won't be filled entirely!
    #rBoundsRect*: array[lidxLim, array[2, int32]]

    # `rOutpS2d`:
    # dim 0:
    #   which computation pass (previous pass feeds into the next)
    # dim 1:
    #   The quads output by the particular computation pass
    # dim 2:
    #   Raw vertex coordinates
    rOutpS2d*: seq[seq[array[quadVertArrLen, Triple[int32]]]]

type
  RectCopl = object
    # `rCoplMainSeq`:
    #   the collection of contiguous coplanar regions of the particular
    #   orientation
    rCoplMainSeq*: seq[RectCoplMain]

    # `rCoplIdxTbl`:
    # Maps
    # * from an index into `cDataOptS2d` and `cDataAdjS2d`
    # * to an index into `rCoplMainSeq`
    rCoplIdxTbl*: OrderedTable[uint, uint]

    ## `rCoplMainIdxTbl`:
    ## Maps
    ## * from an index into `rCoplMainSeq`
    ## * to an index into `cDataOptS2d` and `cDataAdjS2d`
    #rCoplMainIdxTbl*: Table[uint, uint]

    # `rCoplSetSeq`:
    # dim 0:
    #   The coplanar region
    # dim 1:
    #   a `HashSet` containing every 
    #rCoplSetSeq*: seq[HashSet[uint]]

#type
#  RectSlice1d = object
#    asdf*: int

type
  ObjConvert* = object
    # `vnInpSeq`:
    # normals; we don't change these
    vnInpSeq*: seq[seq[float64]]

    # `vtInpSeq`:
    # texture coords; we don't change these
    vtInpSeq*: seq[(float64, float64)]

    # `vInpSeq`:
    # input vertices: obtained from the input `.obj` file
    vInpSeq*: seq[Triple[int32]]

    # `vOptSeq`:
    # vertices contained within `vInpSeq`, but not including duplicates
    vOptSeq*: seq[Triple[int32]]

    # `vOutpSeq`:
    # vertices to be output in the final result `.obj` file
    vOutpSeq*: seq[Triple[int32]]

    # unlikely to have more than a small handful
    #vTbl*: Table[Triple[int32], seq[uint]]

    # `fInpSeq`: faces obtained from input `.obj` file`
    # (must be indexed mode)
    # vertices: `vInpSeq`
    fInpSeq*: seq[seq[Triple[uint]]]

    # `fQuadSeq`:
    # faces converted from triangles (as contained in `fInpSeq`) into quads
    # (or just copied over from `fInpSeq` if we have all quads already)
    # vertices: `vInpSeq`
    fQuadSeq*: seq[seq[Triple[uint]]]

    # `fOptSeq`:
    # faces output by `quadsOptFirst()`
    # vertices: `vOptSeq`
    fOptSeq*: seq[seq[Triple[uint]]]

    # `fSortSeq`:
    # faces output by `quadsSort()`
    # vertices: `vOptSeq`
    fSortSeq*: seq[seq[Triple[uint]]]

    # `fOutpSeq`: faces to be output in final result `.obj` file
    fOutpSeq*: seq[seq[Triple[uint]]]

    #fTbl: Table[array[3, FaceElem], bool]
    #fInpSeq*: seq[array[3, FaceElem]]
    #cTbl*: Table[uint, Cube] # maps `vtIdx` to `Cube`

    # maps from an index into `fInpSeq` to `seq` of indices into `cSeq`
    # (`seq[uint]` in case the input `.obj` has faces shared by multiple
    # `Cube`s)
    #cfPairTbl*: Table[uint, array[2, uint]]

    # `cUnitSeq`: every `CubeUnit` goes here
    cUnitSeq*: seq[CubeUnit]

    # `vUnitInpTbl`:
    # maps from vertices to a `seq` of indices into `cUnitSeq`
    vUnitInpTbl*: Table[Triple[int32], seq[uint]]

    #vUnitOptTbl*: Table[Triple[int32], seq[uint]]

    # `cDataIdxTbl`:
    # maps from a quad's vertices (which should be unique!)
    # to an index into `cDataInpSeq`
    # one of the outputs of `quadsToCubes()`
    cDataIdxTbl*: Table[HashSet[Triple[int32]], uint]

    # `cDataInpSeq`:
    # the initial `seq` of `CubeData` instances
    # these `CubeData` instances make use of the `cUnitIdxSeq` member,
    # but they *do not* make use of the `cInfoArr` member.
    # one of the outputs of `quadsToCubes()`
    cDataInpSeq*: seq[CubeData] #seq[(Cube, seq[uint])]

    #cDataOptArrSeq*: seq[array[cidxLim, seq[uint]]]

    # `cDataOptS2d`:
    # Each outer `seq` contains data for a specific pass for processing of
    # the `CubeData` instances. In reality, we only have one optimization
    # pass (as of this writing)!
    #
    # These `CubeData` instances are the ones that make use of the
    # `cInfoArr` member of the `CubeData` but **not** the `cUnitIdxSeq`
    # member
    cDataOptS2d*: seq[seq[CubeData]]

    
    # `cDataAdjS2d`:
    # dim 0:
    #   hypothetical case where we have multiple optimization passes
    #   changing the cubes/voxels. As of this writing, only a single
    #   element of this index 0 `seq` is used, i.e. only a single pass
    #   produces the values we store (similar to `cDataOptS2d`)
    #   for this.
    # dim 1: which `CubeData` in `cDataOptS2d[...]` we refer to
    # dim 2: each `CubeIdx` of our `CubeData` (the face orientation)
    # dim 3:
    #   the `seq` of `cDataOptS2d[...]` indices for adjacent `CubeData'`s 
    cDataAdjS2d*: seq[seq[array[cidxLim, seq[uint]]]]

    # `rCoplArr`:
    # Stores Directly connected coplanar regions.
    # dim 0:
    #   `CubeIdx`, or which orientation is used by the coplanar region
    # dim 1:
    #rCoplArr*: seq[array[cidxLim, seq[seq[RectCopl]]]]
    #rCoplArr*: array[cidxLim, seq[RectCopl]]
    rCoplArr*: array[cidxLim, RectCopl]

    #rCoplTblArr*: array[cidxLim, ]

    # `rCoplSetSeq`:
    # dim 0:
    #   every possible
    #rCoplSetSeqArr*: array[cidxLim, ]

    #cDataCoplS2d*: seq[seq[array[cidxLim, seq[uint]]]]
    #rDataTblArr*: array[cidxLim, Table[Triple[int32], RectData]]


    # indexes into `vUnitInpTbl[...].`
    #rSortArr*: array[cidxLim, ]

    # `outp`:
    # The output `.obj` file's contents
    outp*: string

    #isTri*: bool
    mode*: Mode
    scalePow2*: uint
    scale*: float64
    #cubeSeq:

proc maybeTrisToQuads(
  self: var ObjConvert
) =
  #var fTriPairTbl: Table[array[2, uint], uint]
  #var qDiagTbl: Table[array[2, uint], seq[uint]]
  #for fSeq in self.fInpSeq:
  #var quadTbl: Triple[Table[uint, uint]]
  #var quadTbl: Table[seq[uint], uint]
  #var tToQTbl: Table[uint, seq[uint]]
  #var quadTbl: array[4, Table[uint, uint]]
  var haveAllQuads: bool = true
  var haveAllTris: bool = true
  for j in 0 ..< self.fInpSeq.len():
    let fSeq = self.fInpSeq[j]
    if fSeq.len() != 4:
      haveAllQuads = false
    if fSeq.len() != 3:
      haveAllTris = false
  doAssert(
    (
      haveAllQuads and not haveAllTris
    ) or (
      not haveAllQuads and haveAllTris
    )
  )
  if haveAllQuads:
    self.fQuadSeq = self.fInpSeq
    self.fInpSeq.setLen(0)
    return

  var triPairTbl: Table[array[2, Triple[int32]], seq[uint]]
  for j in 0 ..< self.fInpSeq.len():
    let fSeq = self.fInpSeq[j]
    doAssert(
      fSeq.len() == 3
    )
    var maxDistPair: array[2, Triple[int32]]
    var prevMaxDist: float64 = 0.0
    for i in 0 ..< fSeq.len():
      let fa = fSeq[(i + 0) mod fSeq.len()].v[uint(fidxV)]
      let fb = fSeq[(i + 1) mod fSeq.len()].v[uint(fidxV)]
      let va = self.vInpSeq[fa - 1]
      let vb = self.vInpSeq[fb - 1]
      let tempDist: float64 = nonSqrtDist(va, vb)
      #var s: string
      #s.add "i:" & $i & "; "
      #s.add "f:(" & $fa & " " & $fb & ")"
      #s.add "; "
      #s.add "v:(" & $va & " " & $vb & ") "
      #s.add ";   "
      #s.add "td:" & $tempDist
      #s.add "; "

      if (i == 0) or (tempDist > prevMaxDist):
        maxDistPair[0] = va
        maxDistPair[1] = vb
        prevMaxDist = tempDist
        #s.add "adding it"
      #echo s
      #elif tempDist > prevMaxDist:
      #  maxDistPair[0] = va
      #  maxDistPair[1] = vb
      #  prevMaxDist = tempDist
    #echo ""
    if maxDistPair[0] > maxDistPair[1]:
      swap(maxDistPair[0], maxDistPair[1])
      #let tempSwap = maxDistPair[0]
      #maxDistPair[0] = maxDistPair[1]
      #maxDistPair[1] = tempSwap

    if maxDistPair notin triPairTbl:
      #var s: string
      #s.add "adding to triPairTbl: "
      #s.add $maxDistPair
      #echo s
      triPairTbl[maxDistPair] = @[]
    proc doAppend(
      self: var ObjConvert,
      key: var array[2, Triple[int32]],
      val: var seq[uint],
      j: int,
    ) =
      #echo "test"
      doAssert(
        val.len() < 2
      )
      val.add uint(j)
      if val.len() == 2:
        #echo "val.len() == 2"
        var cSet: HashSet[Triple[uint]]
        #for i in 0 ..< val.len():
        for idx in val:
          let fSeq = self.fInpSeq[idx]
          #for jdx in fSeq:
          #  discard
          for f in fSeq:
            cSet.incl(f)
        doAssert(
          cSet.len() == 4
        )
        var toAdd: seq[Triple[uint]]
        for c in cSet:
          # we sort the quads later, so it doesn't matter what order we put
          # them in here
          toAdd.add c
        self.fQuadSeq.add toAdd
        #cSet
    #assert(
    #  triPairTbl[maxDistPair].len() > 2
    #)
    self.doAppend(
      key=maxDistPair,
      val=triPairTbl[maxDistPair],
      j=j,
    )
    #var vArr: array[3, Triple[int32]]
    #var myMinIdx = Triple[uint](v: [0, 0, 0])
    #var myMaxIdx = Triple[uint](v: [0, 0, 0])
    #var myMinVal = Triple[int32](v: [0, 0, 0])
    #var myMaxVal = Triple[int32](v: [0, 0, 0])
    ##var key: array[2, uint]
    #for i in 0 ..< fSeq.len():
    #  let f = fSeq[i]
    #  let myIdx = f.v[uint(fidxV)]
    #  vArr[i] = self.vInpSeq[myIdx - 1]

    ##for i in 0 ..< vArr.len(): #fSeq.len():
    #for k in 0 ..< myMinVal.v.len():
    #  myMinVal.v[k] = vArr[0].v[k]
    #  myMaxVal.v[k] = vArr[0].v[k]
    #for i in 0 ..< vArr.len(): #fSeq.len():
    #  for k in 0 ..< myMinIdx.v.len():
    #    if vArr[i].v[k] < vArr[myMinIdx.v[k]].v[k]:
    #      myMinIdx.v[k] = uint(i)
    #      myMinVal.v[k] = vArr[i].v[k]
    #    if vArr[i].v[k] > vArr[myMaxIdx.v[k]].v[k]:
    #      myMaxIdx.v[k] = uint(i)
    #      myMaxVal.v[k] = vArr[i].v[k]
    #var s: string
    #s.add $vArr
    #s.add ":   "
    #s.add $myMinIdx
    #s.add " "
    #s.add $myMaxIdx
    #s.add ":   "
    #s.add $myMinVal
    #s.add " "
    #s.add $myMaxVal
    #echo s
    ##echo ""
    ##for i in 0 ..< fSeq.len():
    ##  let f = fSeq[i]
    ##  let myIdx = f.v[uint(fidxV)]
    ##  #if i == 0:
    ##  #  myMin = vArr[i]
    ##  #  myMax = vArr[i]
    ##  #else:
    #
    ##if key notin qDiagTbl:
    ##  qDiagTbl[key] = @[]
    ##for in in 0 ..< fSeq.len():
    ##  qDiagTbl

  self.fInpSeq.setLen(0)

proc quadsOptFirst(
  self: var ObjConvert
) =
  var vTbl: Table[Triple[int32], uint]
  for fSeq in self.fQuadSeq:
    doAssert(
      fSeq.len() == 4
    )
    var tempFSeq: seq[Triple[uint]]
    for i in 0 ..< fSeq.len():
      #var f = fSeq[i]
      var f: Triple[uint]
      for j in 0 ..< f.v.len():
        f.v[j] = fSeq[i].v[j]

      let myIdx = f.v[uint(fidxV)]
      let vert = self.vInpSeq[myIdx - 1]

      if vert notin vTbl:
        #vTbl[vert] = uint(self.vOptSeq.len()) #myIdx
        self.vOptSeq.add vert
        vTbl[vert] = uint(self.vOptSeq.len()) #myIdx

      f.v[uint(fidxV)] = vTbl[vert]

      tempFSeq.add f
    #echo tempFSeq
    self.fOptSeq.add tempFSeq

  #for v, idx in vTbl:
  #  var temp: string
  #  temp.add $v
  #  temp.add ": "
  #  temp.add $idx
  #  echo temp
  #echo "--------"
  self.vInpSeq.setLen(0)
  self.fQuadSeq.setLen(0)

proc quadsSort(
  self: var ObjConvert
) =
  #var changed: bool = false
  #while not changed:

  for fSeq in self.fOptSeq:
    #echo fSeq
    doAssert(
      fSeq.len() == 4
    )
    var sorted: seq[Triple[uint]]
    for f in fSeq:
      sorted.add f
    # insertion sort since these are tiny `seq`s!
    for i in 1 ..< sorted.len:
      var j = i
      let x = sorted[i]
      while (
        (
          j > 0
        ) and (
          (
            self.vOptSeq[sorted[j - 1].v[uint(fidxV)] - 1]
          ) > (
            self.vOptSeq[x.v[uint(fidxV)] - 1] #sorted[j]
          )
        )
      ):
        sorted[j] = sorted[j - 1]
        j -= 1
      #while j > 0 and
      sorted[j] = x
    # this swap is necessary to maintain the winding order, etc.
    #let tempSwap = sorted[2]
    #sorted[2] = sorted[3]
    #sorted[3] = tempSwap
    swap(sorted[2], sorted[3])
    self.fSortSeq.add sorted
    #self.fOutpSeq.add sorted

    #for j in 0 ..< fSeq.len():
    #  let f = fSeq[j]
    #  doAssert(f.len() == 4)
    #  #for i in 0 ..< f.v.len():
    #  #  self.cTbl[j]
  self.fOptSeq.setLen(0)

proc mkCubeUnit(
  self: var ObjConvert,
  vSeq: var seq[Triple[int32]],
  fSeq: seq[Triple[uint]],
  fIdx: int,
): CubeUnit =
  doAssert(
    fSeq.len() == 4
  )
  #var vArr: array[4, Triple[int32]]
  #var vNorm: (ReducedCubeIdx, array[4, Triple[int32]])
  var cUnit: CubeUnit
  cUnit.fIdx = fIdx
  for i in 0 ..< cUnit.vArr.len():
    cUnit.vArr[i] = vSeq[fSeq[i].v[uint(fidxV)] - 1]
    cUnit.n[i] = cUnit.vArr[i] - cUnit.vArr[0]
    #for j in 0 ..< cUnit.n[i].v.len():
    #  cUnit.n[i].v[j] = cUnit.vArr[i].v[j] - cUnit.vArr[0].v[j]

  var foundRci: bool = false
  for rcidx in rcidxFront ..< rcidxLim:
    case rcidx:
    of rcidxFront:
      var myFoundRci: bool = true
      for i in 0 ..< cUnit.n.len():
        if cUnit.n[i].v != cubeOrderA2d[cidxFront].c[i].v:
          myFoundRci = false
      if myFoundRci:
        foundRci = true
        cUnit.rcidx = some(rcidxFront)
    of rcidxLeft:
      var myFoundRci: bool = true
      for i in 0 ..< cUnit.n.len():
        if cUnit.n[i].v != cubeOrderA2d[cidxLeft].c[i].v:
          myFoundRci = false
      if foundRci:
        doAssert(
          not myFoundRci
        )
      elif myFoundRci:
        foundRci = true
        cUnit.rcidx = some(rcidxLeft)
    of rcidxBottom:
      var myFoundRci: bool = true
      for i in 0 ..< cUnit.n.len():
        if cUnit.n[i].v != cubeOrderA2d[cidxBottom].c[i].v:
          myFoundRci = false
      if foundRci:
        doAssert(
          not myFoundRci
        )
      elif myFoundRci:
        foundRci = true
        cUnit.rcidx = some(rcidxBottom)
    else:
      doAssert(false)
  doAssert(foundRci)

  #case cUnit.rcidx.get():
  #of rcidxFront:
  #  vnConvArr[cUnit.rcidx.get()][0] = (
  #
  #  )
  #of rcidxLeft:
  #  discard
  #of rcidxBottom:
  #  discard
  #else:
  #  doAssert(false)
  let vnIdx = fSeq[0].v[uint(fidxVn)]
  let vn = self.vnInpSeq[vnIdx - 1]
  var foundVn: bool = false
  for i in 0 ..< vn.len():
    if round(vn[i]) == 1:
      doAssert(not foundVn)
      foundVn = true
      vnConvArr[cUnit.rcidx.get()][0] = vnIdx
    elif round(vn[i]) == -1:
      doAssert(not foundVn)
      foundVn = true
      vnConvArr[cUnit.rcidx.get()][1] = vnIdx
    elif round(vn[i]) == 0:
      #foundVn = true
      discard
    else:
      doAssert(false)
  #if vn.contains(1.0):
  #  discard
  #elif vn.contains(-1.0):
  #  discard
  #else:
  #  doAssert(false)
  doAssert(foundVn)
  result = cUnit

proc cubeVertSort(
  cube: Cube
): Cube =
  for i in 0 ..< cube.c.len():
    result.c[i] = cube.c[i]
  for i in 1 ..< result.c.len():
    var j = i
    let x = result.c[i]
    while (
      (
        j > 0
      ) and (
        (
          #self.vOptSeq[sorted[j - 1].v[uint(fidxV)] - 1]
          result.c[j - 1]
        ) > (
          #self.vOptSeq[x.v[uint(fidxV)] - 1] #sorted[j]
          x
        )
      )
    ):
      result.c[j] = result.c[j - 1]
      j -= 1
    result.c[j] = x
  #swap(result.c[2], result.c[3])
  #swap(result.c[6], result.c[7])
proc quadsToCubes(
  self: var ObjConvert
) =
  #for fSeq in self.fSortSeq:

  #var vnTbl: Table[Triple[int32], seq[uint]]
  #var cnTbl: Table[uint, seq[uint]]
  #var cPartSeq: seq[Cube]

  for fSortIdx in 0 ..< self.fSortSeq.len():
    let fSeq = self.fSortSeq[fSortIdx]
    let cUnit = self.mkCubeUnit(
      vSeq=self.vOptSeq,
      fSeq=fSeq,
      fIdx=fSortIdx,
    )
    #if cUnit.rcidx == rcidxFront:
    for unitVArrIdx in 0 ..< cUnit.vArr.len():
      let unitV = cUnit.vArr[unitVArrIdx]
      if unitV notin self.vUnitInpTbl:
        self.vUnitInpTbl[unitV] = @[]
      doAssert(
        uint(self.cUnitSeq.len()).notin self.vUnitInpTbl[unitV]
      )
      self.vUnitInpTbl[unitV].add uint(self.cUnitSeq.len())
    self.cUnitSeq.add cUnit
  #for k, v in self.vNormTbl:
  #  echo $k & ": " & $v

  #var cvTbl: Table[]

  #var cDataIdxTbl: Table[HashSet[Triple[int32]], uint]
  #echo self.cUnitSeq.len()
  for cUnitIdx in 0 ..< self.cUnitSeq.len():
    let cUnit = self.cUnitSeq[cUnitIdx]
    #if cUnit.rcidx == rcidxFront:
    const
      tempLen = 2
    var cube: array[tempLen, Cube]
    var found: array[tempLen, bool] = [true, true]
    var vOffsArr: array[tempLen, array[quadVertArrLen, Triple[int32]]]
    for i in 0 ..< cUnit.vArr.len():
      let unitV = cUnit.vArr[i]
      for k in 0 ..< tempLen:
        vOffsArr[k][i].v[0] = unitV.v[0]
        vOffsArr[k][i].v[1] = unitV.v[1]
        vOffsArr[k][i].v[2] = unitV.v[2]
      doAssert(
        cUnit.rcidx.isSome
      )
      case cUnit.rcidx.get():
      of rcidxFront:
        vOffsArr[0][i].v[2] += 1
        vOffsArr[1][i].v[2] -= 1
      of rcidxLeft:
        vOffsArr[0][i].v[0] += 1
        vOffsArr[1][i].v[0] -= 1
      of rcidxBottom:
        vOffsArr[0][i].v[1] += 1
        vOffsArr[1][i].v[1] -= 1
      else:
        doAssert(false)

      cube[0].c[i] = unitV
      cube[0].c[i + cUnit.vArr.len()] = vOffsArr[0][i]
      cube[1].c[i + cUnit.vArr.len()] = unitV
      cube[1].c[i] = vOffsArr[1][i]

      for k in 0 ..< tempLen:
        #var s: string
        if vOffsArr[k][i].notin self.vUnitInpTbl:
          found[k] = false
        #s.add "k:" & $k & " i:" & $i & "; " & $vOffsArr[k][i] & "; "
        #s.add $found[k]
        #echo s
      #echo ""
    #echo ""
    for k in 0 ..< tempLen:
      if found[k]:
        #echo "found[" & $k & "]"
        #var cDataFound: bool = true
        var cSet: HashSet[Triple[int32]] = toHashSet(cube[k].c)
        #for i in 0 ..< cube[k].c.len():
        #echo "cube:" & $cube[k]
        #for v in cube[k].c:
        #  cSet.incl v
        #echo cSet.len()
        doAssert(
          cSet.len() == cubeNumVerts
        )
        if cSet.notin self.cDataIdxTbl:
          #echo "cSet.notin cDataIdxTbl: " & $cUnitIdx
          self.cDataIdxTbl[cSet] = uint(self.cDataInpSeq.len())
          self.cDataInpSeq.add CubeData(
            c: cube[k].cubeVertSort(),
            cUnitIdxSeq: @[uint(cUnitIdx)],
          )
          #var s: string
          #s.add " -- "
          #echo $cube[k].c
          #echo ""
          #self.cSeq.add cube[k]
        else:
          #echo "cSet.contains cDataIdxTbl: " & $cUnitIdx
          let cDataIdx = self.cDataIdxTbl[cSet]
          let cData = addr self.cDataInpSeq[cDataIdx]
          doAssert(
            uint(cUnitIdx).notin cData.cUnitIdxSeq
          )
          cData.cUnitIdxSeq.add uint(cUnitIdx)
    #echo "----"
  #for cData in self.cDataInpSeq:
  #  #let cData = addr self.cDataInpSeq[^1]
  #  echo $cData.c.c
  #  for cidx in CubeIdx(0) ..< cidxLim:
  #    var s: string
  #    s.add $cidx & ": "
  #    var cOrder: CubeOrder
  #    let cOrder1 = addr cubeOrderA2d[cidx]
  #    for i in 0 ..< quadVertArrLen:
  #      ##cOrder.c[i] = cOrder1.c[i]
  #      let myTriple = cOrder1.c[i]
  #      let x = myTriple.v[0]
  #      let y = myTriple.v[1]
  #      let z = myTriple.v[2]
  #      let tempIdx = (x * 2 * 2) + (y * 2) + z
  #      ##s.add $tempIdx & ": " & $myTriple.v & "  "
  #      #let tempIdx = toCubeOrderIdx(cidx=cidx, idx=i)
  #      cOrder.c[i] = cData.c.c[tempIdx] - cData.c.c[0]
  #    s.add $cOrder.c
  #    s.add " -> "
  #    s.add $(cOrder.c == cOrder1.c)
  #    echo s
  #  echo "----"
  #echo ""

  #for cData in self.cDataInpSeq:
  #  echo cData
  #  for unitIdx in cData.cUnitIdxSeq:
  #    echo self.cUnitSeq[unitIdx]
  #  echo ""

  #for j in 0 ..< self.cnSeq.len():
  #  let unit = self.cnSeq[j]

proc cubesOptFirst(
  self: var ObjConvert
) =
  var toAddSeq: seq[CubeData]
  self.cDataOptS2d.add toAddSeq

  #var toAddArr: array[cidxLim, seq[(uint, uint)]]

  #echo self.cDataInpSeq.len()
  for j in 0 ..< self.cDataInpSeq.len():
    let cData = addr self.cDataInpSeq[j]

    let cInfoArr = toCubeDataInfoArr(
      cUnitSeq=addr self.cUnitSeq,
      cData=cData,
    )
    var doIt: bool = true
    for cidx in CubeIdx(0) ..< cidxLim:
      if not cInfoArr[cidx].cidx.isSome:
        doIt = false
    if doIt:
      var toAdd = CubeData(
        c: cData.c,
        cInfoArr: cInfoArr,
      )
      #for cInfo in toAdd.cInfoArr:
      #  toAddArr[cInfo.cidx].add (uint(j), cInfo.unitIdx)

      self.cDataOptS2d[0].add toAdd

  self.cDataInpSeq.setLen(0)

proc findAdjCubes(
  self: var ObjConvert,
  optPrevSeqIdx: Option[int]=none(int),
): seq[array[cidxLim, seq[uint]]] =
  var tempPrevSeqIdx: int = 0
  if optPrevSeqIdx.isSome:
    tempPrevSeqIdx = optPrevSeqIdx.get()
  else:
    tempPrevSeqIdx = self.cDataOptS2d.len() - 1
  let prevSeq = addr self.cDataOptS2d[tempPrevSeqIdx]

  var myTbl: Table[Triple[int32], seq[uint]]
  for j in 0 ..< prevSeq[].len():
    let cData = addr prevSeq[j]
    for c in cData.c.c:
      if c notin myTbl:
        var toAddSeq: seq[uint]
        myTbl[c] = toAddSeq

      for i in myTbl[c]:
        let cData1 = addr prevSeq[i]
        let vLeftSet = toHashSet(cData.c.c)
        let vRightSet = toHashSet(cData1.c.c)
        #var cond: bool = true
        #for c0 in cData.c.c:
        #  var found: bool = false
        #  for c1 in cData1.c.c:
        #    if c0 == c1:
        #      found = true
        #  if not found:
        #    cond = false
        #if not cond:
        if vLeftSet == vRightSet:
          #var s: string
          echo "eek! " & $j & ": " & $vLeftSet
          #echo $j & ": " & $(vLeftSet == vRightSet)
          doAssert(false)
      myTbl[c].add uint(j)

  for j in 0 ..< prevSeq[].len():
    let cData0 = addr prevSeq[j]
    #let cUnit0 = addr self.cUnitSeq
    var toAdd: array[cidxLim, seq[uint]]
    #echo $j & ": " & $cData0.c
    for v in cData0.c.c:
      #for i in 0 ..< prevSeq[].len():
      for i in myTbl[v]:
        let cData1 = addr prevSeq[i]
        if int(i) != j:
          #for cInfo0 in cData0.cInfoArr:
          for k in CubeIdx(0) ..< cidxLim:
            let cInfo0 = cData0.cInfoArr[k]
            if not cInfo0.cidx.isSome:
              echo $k
            doAssert(cInfo0.cidx.isSome)
            let cInfo1 = (
              addr cData1.cInfoArr[revCubeIdxArr[cInfo0.cidx.get()]]
            )
            let cUnit0 = addr self.cUnitSeq[cInfo0.unitIdx]
            let cUnit1 = addr self.cUnitSeq[cInfo1.unitIdx]
            if isAdjSide(left=cUnit0[], right=cUnit1[]):
              ##var s: string
              #echo "have adjacent side: " & $i
              #echo $cInfo0.cidx & " " & $cInfo1.cidx
              #echo cUnit0.vArr
              #echo cUnit1.vArr
              #echo ""
              toAdd[cInfo0.cidx.get()].add i
      #for cInfo in cData.cInfoArr:
      #  let revCidx = revCubeIdxArr[cInfo.cidx]
    #echo "----"
    result.add toAdd


proc addOutpFace(
  self: var ObjConvert,
  cData: ptr CubeData,
  foundVTbl: var Table[Triple[int32], uint],
  vArr: var array[quadVertArrLen, Triple[int32]],
  cidx: CubeIdx,
) =
  #let cData: ptr CubeData = addr self.cDataOptS2d[^1][idx]
  let vnIdx = toVnIdx(cidx=cidx)
  let cInfo = addr cData.cInfoArr[cidx]
  let cUnit: ptr CubeUnit = addr self.cUnitSeq[cInfo.unitIdx]
  let quad = addr self.fSortSeq[cUnit.fIdx]

  var fSeq: seq[Triple[uint]]
  for i in 0 ..< quadVertArrLen:
    #let v = cUnit.vArr[i]
    let v = vArr[i]
    var fTemp: Triple[uint]
    var vSeqIdx: uint = 0

    if v notin foundVTbl:
      vSeqIdx = uint(self.vOutpSeq.len())
      foundVTbl[v] = vSeqIdx
      self.vOutpSeq.add v
    else:
      # prevent duplicate output vertices
      vSeqIdx = foundVTbl[v]

    fTemp.v[uint(fidxV)] = vSeqIdx + 1

    # TODO:
    # The UV coordinates should be the same for each element of
    # `quad` because each quad is a solid color. Maybe this could be
    # changed later if I decide to support "real" textures?
    fTemp.v[uint(fidxVt)] = quad[i].v[uint(fidxVt)]
    #fTemp.v[uint(fidxVt)] = vtIdxArr[i]
    fTemp.v[uint(fidxVn)] = vnIdx
    fSeq.add fTemp
  case cidx:
  of cidxBack, cidxRight, cidxBottom:
    self.fOutpSeq.add fSeq
  of cidxFront, cidxLeft, cidxTop:
    # Reverse the order of the vertices.
    # I think this is for ensuring correct winding order.
    # Also why can't `for` loops go in reverse order?
    # Maybe they can, and I'm just not aware of how.
    self.fOutpSeq.add fSeq.reversed()
  else:
    discard

proc dbgVerifyHollow(
  self: var ObjConvert
) =
  # old debug way to verify that we successfully hollowed out the voxel
  # model!
  let adjSeq = addr self.cDataAdjS2d[^1]
  #var myVertTbl: Table[Triple[int32], uint]

  var foundVTbl: Table[Triple[int32], uint]

  for idx in 0 ..< self.cDataOptS2d[^1].len():
    let cData: ptr CubeData = addr self.cDataOptS2d[^1][idx]
    #let myAdj = addr
    for cidx in CubeIdx(0) ..< cidxLim:
      let adjSeq = addr adjSeq[idx][cidx]
      if adjSeq[].len() > 0:
        # If we have another cube on this side (indicated by `cidx`),
        # we don't want to do further processing of this specific side.
        # This is for the purposes of hollowing out the voxel model.
        discard
      else:
        #echo $idx & ": " & $cidx & " " & $cData.c.c
        let cInfo = addr cData.cInfoArr[cidx]
        let cUnit: ptr CubeUnit = addr self.cUnitSeq[cInfo.unitIdx]
        #let quad = addr self.fSortSeq[cUnit.fIdx]
        #var fSeq: seq[Triple[uint]]
        self.addOutpFace(
          cData=cData,
          foundVTbl=foundVTbl,
          vArr=cUnit.vArr,
          #vtIdxArr=[
          #  #quad[i].v[uint(fidxVt)] for i in 0 ..< quadVertArrLen
          #  quad[0].v[uint(fidxVt)],
          #  quad[1].v[uint(fidxVt)],
          #  quad[2].v[uint(fidxVt)],
          #  quad[3].v[uint(fidxVt)],
          #],
          cidx=cidx,
        )
  #--------
proc dbgVerifyRectCopl(
  self: var ObjConvert
) =
  var foundVTbl: Table[Triple[int32], uint]
  for cidx in CubeIdx(0) ..< cidxLim:
    echo "dbgVerifyRectCopl: " & $cidx
    template rCopl: untyped = self.rCoplArr[cidx]
    template rCoplIdxTbl: untyped = rCopl.rCoplIdxTbl
    #for idx in 0 ..< self.cDataOptS2d[^1].len():
    #  let adjSeq
    var foundSet: HashSet[uint]
    var myCnt: uint = 0

    #let chngArr = addr coplCidxVidxA2d[cidx]
    #echo "verify chngArr: " & $chngArr[]
    for idx, mainIdx in rCoplIdxTbl:
      #echo mainIdx
      if mainIdx in foundSet:
        continue
      #echo "idx, mainIdx: " & $idx & " " & $mainIdx
      myCnt += 1
      foundSet.incl mainIdx
      let cData: ptr CubeData = addr self.cDataOptS2d[^1][idx]
      #let cInfo = 

      template rCoplMain: untyped = rCopl.rCoplMainSeq[mainIdx]
      #var v = Triple[int32](v: [0, 0, 0])
      #var prevV = Triple[int32](v: [0, 0, 0])

      let firstVArr = addr rCoplMain.rOutpS2d[^1][0]
      #echo "firstVArr: " & $firstVArr[]

      for jdx in 0 ..< rCoplMain.rOutpS2d[^1].len():
        let vArr = addr rCoplMain.rOutpS2d[^1][jdx]
        #let myIdx: uint = coplCidxVidxArr[cidx]

        #for vIdx in 0 ..< vArr[].len():
        #  if (
        #    firstVArr[0].v[myIdx] != vArr[vIdx].v[myIdx]
        #  ):
        #    echo "found different: "
        #    echo $jdx & " " & $vIdx & "  " & $myIdx
        #echo "vArr: " & $vArr[]

        self.addOutpFace(
          cData=cData,
          foundVTbl=foundVTbl,
          vArr=vArr[],
          cidx=cidx,
        )
    echo "dbgVerifyRectCopl: " & $myCnt

proc cubesOptSecond(
  self: var ObjConvert
) =
  # step 1: if two cubes are directly beside each other, don't draw the
  # faces between them
  # step 2: if all faces in a vertex are removed by the above rule, delete
  # the vertex too
  # done
  #var toAddArr: array[cidxLim, seq[(uint, uint)]]
  #self.cDataOptArrSeq.add toAddArr

  var currSeq: seq[CubeData]
  let prevSeq = addr self.cDataOptS2d[^1]
  var mySetTbl: Table[HashSet[Triple[int32]], uint]
  for j in 0 ..< prevSeq[].len():
    let cData = addr prevSeq[j]
    let tempSet: HashSet[Triple[int32]] = toHashSet(cData.c.c)
    if tempSet notin mySetTbl:
      #myTbl[tempSet] = cData[]
      mySetTbl[tempSet] = uint(j)
      currSeq.add cData[]
    else:
      echo "dbg test: " & $j & ": " & $cData.c.c
  #self.cDataOptS2d[^2].setLen(0)
  prevSeq[].setLen(0)
  self.cDataOptS2d.add currSeq

  self.cDataAdjS2d.add self.findAdjCubes(
    #optPrevSeqIdx=some(self.cDataOptS2d.len() - 1)
  )
  let adjSeq = addr self.cDataAdjS2d[^1]
  doAssert(
    self.cDataOptS2d[^1].len() == adjSeq[].len()
  )
  #mySetTbl.clear()
  #--------

  #for j in 0 ..< adjSeq.len():
  #  let myArr = addr adjSeq[j]

  #echo prevSeq[].len()
  #echo adjSeq.len()

  #let prevArrSeq = addr self.cDataOptArrSeq[^2]
  #let currArrSeq = addr self.cDataOptArrSeq[^1]

  #for j in 0 ..< prevSeq[].len():
  #  let cData = addr prevSeq[j]
  #  for cInfo in cData.cInfoArr:
  #    toAddArr[cInfo.cidx].add uint(j) #cInfo.unitIdx


  #prevSeq[].setLen(0)
  #self.cDataOptS2d[^2].setLen(0)

proc rectCoplsFirst(
  self: var ObjConvert
) =
  # `adjSeq` is stores the information about adjacent *cubes*.
  let adjSeq = addr self.cDataAdjS2d[^1]

  var tempSeq: seq[array[cidxLim, bool]]

  proc myFloodFill(
    self: var ObjConvert,
    idx: int,
    cidx: CubeIdx,
  ) =
    template rCopl: untyped = self.rCoplArr[cidx]
    template rCoplMainSeq: untyped = rCopl.rCoplMainSeq
    template rCoplIdxTbl: untyped = rCopl.rCoplIdxTbl
    if (
      (
        uint(idx) in rCoplIdxTbl
      ) or (
        not tempSeq[idx][cidx]
      )
    ):
      return

    let cData0: ptr CubeData = addr self.cDataOptS2d[^1][idx]
    let cInfo0 = addr cData0.cInfoArr[cidx]
    let cUnit0 = addr self.cUnitSeq[cInfo0.unitIdx]
    cUnit0.cidx = cInfo0.cidx
    let quad0 = addr self.fSortSeq[cUnit0.fIdx]
    let quadVt0 = quad0[0].v[uint(fidxVt)]
    #echo "quadVt0: " & $quadVt0

    var toAddRcm: RectCoplMain
    var myRcmOutpSeq: seq[array[quadVertArrLen, Triple[int32]]]

    var deq: Deque[uint]
    deq.addLast uint(idx)
    while deq.len() > 0:
      let jdx = deq.popFirst()
      if (
        (
          jdx in rCoplIdxTbl
        )
        #or (
        #  not tempSeq[jdx][cidx]
        #)
      ):
        #echo "`jdx` in `rCoplIdxTbl`: " & $jdx
        continue

      let cData1: ptr CubeData = addr self.cDataOptS2d[^1][jdx]
      let cInfo1 = addr cData1.cInfoArr[cidx]
      let cUnit1 = addr self.cUnitSeq[cInfo1.unitIdx]
      #echo $cidx & " " & $cInfo1.cidx
      cUnit1.cidx = cInfo1.cidx
      let quad1 = addr self.fSortSeq[cUnit1.fIdx]
      let quadVt1 = quad1[0].v[uint(fidxVt)]
      if quadVt0 == quadVt1:
        #echo "quadVt: " & $quadVt0 & " " & $quadVt1
        # if `jdx` is Inside:
        #for cjdx in CubeIdx(0) ..< cidxLim:
        #  if (
        #    (
        #      cjdx != cidx
        #    ) and (
        #      cjdx != revCubeIdxArr[cidx]
        #    )
        #  ):

        #--------
        # Here we finally add to the particular coplanar region
        #echo (
        #  $(
        #    jdx in rCoplIdxTbl
        #  ) & (
        #    ": " & $jdx & " " & $cUnit1.vArr
        #  ) & (
        #    ": " & $cInfo1.unitIdx
        #  )
        #)
        #doAssert(
        #  cond=jdx notin rCoplIdxTbl,
        #  msg="eek! found `jdx`: " & $jdx,
        #)
        rCoplIdxTbl[jdx] = uint(rCoplMainSeq.len())
        myRcmOutpSeq.add cUnit1.vArr
        #--------
        #template myAdjSeq1: untyped = adjSeq[jdx][cidx]
        #for zdx in 0 ..< myAdjSeq1.len():
        #  # add the node to the west of `jdx` to the end of `deq`.
        #  # add the node to the east of `jdx` to the end of `deq`.
        #  # add the node to the north of `jdx` to the end of `deq`.
        #  # add the node to the south of `jdx` to the end of `deq`.
        #  let temp = myAdjSeq1[zdx]
        #  if temp notin foundSet:
        #    foundSet.incl temp
        #    deq.addLast myAdjSeq1[zdx]
        #var myTbl: Table[CubeIdx, bool]

        for ckdx in CubeIdx(0) ..< cidxLim:
          if (
            (
              ckdx == revCubeIdxArr[cidx]
            ) or (
              ckdx == cidx
            )
          ):
            #echo "ckdx loop: " & $cidx & " " & $ckdx
            #echo "ckdx == rev: " & $(ckdx == revCubeIdxArr[cidx])
            #echo "ckdx == cidx: " & $(ckdx == cidx)
            continue
          let myAdjSeq1 = addr adjSeq[jdx][ckdx]
          for zdx in 0 ..< myAdjSeq1[].len():
            let kdx = myAdjSeq1[zdx]

            let cData2: ptr CubeData = addr self.cDataOptS2d[^1][kdx]
            let cInfo2 = addr cData2.cInfoArr[cidx]
            let cUnit2 = addr self.cUnitSeq[cInfo2.unitIdx]
            let quad2 = addr self.fSortSeq[cUnit2.fIdx]
            let quadVt2 = quad2[0].v[uint(fidxVt)]
            #echo $quadVt1 & " " & $quadVt2

            let myAdjSeq2 = addr adjSeq[kdx][cidx]
            if myAdjSeq2[].len() > 0:
              # check for if this face is entirely obscured
              #discard
              continue
            #elif kdx notin rCoplIdxTbl:
            #if not tempSeq[kdx][cidx]: #or tempSeq[kdx][ckdx]:
            #  discard
            #if not tempSeq[kdx][ckdx]: #or not tempSeq[kdx][ckdx]:
            #  discard
            ##elif kdx notin rCoplIdxTbl:
            #else:
            #if (
            #  (
            #    kdx notin rCoplIdxTbl
            #  ) and (
            #    quadVt2 == quadVt0
            #  )
            #):
            if fastIsCoplanar(
              left=cUnit1[],
              right=cUnit2[],
            ):
              deq.addLast kdx
            else:
              echo "not coplanar? " & $cidx & " " & $ckdx
              echo "cUnit1.vArr:" & $cUnit1[].vArr
              echo "cUnit2.vArr:" & $cUnit2[].vArr

        #for ckdx in CubeIdx(0) ..< cidxLim:
        #  template myAdjSeq1: untyped = adjSeq[jdx][ckdx]
        #  for zdx in 0 ..< myAdjSeq1.len():
        #    let kdx = myAdjSeq1[zdx]
        #    let cData2: ptr CubeData = addr self.cDataOptS2d[^1][kdx]
        #    let cInfo2 = addr cData2.cInfoArr[ckdx]
        #    let cUnit2 = addr self.cUnitSeq[cInfo2.unitIdx]
        #    cUnit2.cidx = cInfo2.cidx
        #    echo "test ckdx: " & $ckdx & " " & $kdx & " " & $zdx
        #    echo "cUnit1.vArr: " & $cUnit1[].vArr
        #    echo "cUnit2.vArr: " & $cUnit2[].vArr
        #    let tempIsCoplanarEtc = (
        #      isCoplanarEtc(
        #        left=cUnit1[],
        #        right=cUnit2[],
        #      )
        #    )
        #    echo "isCoplanarEtc: " & $tempIsCoplanarEtc
        #    if (
        #      (
        #        tempIsCoplanarEtc
        #      ) 
        #      #and (
        #      #  kdx notin rCoplIdxTbl
        #      #  #true
        #      #)
        #    ):
        #      echo "deq.addLast: " & $kdx
        #      #rCoplIdxTbl[kdx] = uint(rCoplMainSeq.len())
        #      deq.addLast kdx
        #--------
    myRcmOutpSeq.sort(myQuadCmp)
    toAddRcm.rOutpS2d.add myRcmOutpSeq
    rCoplMainSeq.add toAddRcm
    

    #let cDataJ: ptr CubeData = addr self.cDataOptS2d[^1][jdx]
    #let cInfoJ = addr cDataJ.cInfoArr[cjdx]
    #let cUnitJ: ptr CubeUnit = addr self.cUnitSeq[cInfoJ.unitIdx]

  for idx in 0 ..< self.cDataOptS2d[^1].len():
    #let cDataI: ptr CubeData = addr self.cDataOptS2d[^1][idx]

    var myCidxValidArr: array[cidxLim, bool]
    for cidx in CubeIdx(0) ..< cidxLim:
      myCidxValidArr[cidx] = true

    for cidx in CubeIdx(0) ..< cidxLim:
      #if myCidxValidArr[cidx]: # this is probably wrong!
      #for cjdx in CubeIdx(0) ..< cidxLim:
      if (
        (
          adjSeq[idx][cidx].len() > 0
        )
        #or (
        #  cjdx == revCubeIdxArr[cidx]
        #)
      ):
        #echo "deasserting here: " & $cidx & " " & $cjdx
        myCidxValidArr[cidx] = false
    tempSeq.add myCidxValidArr

    #echo "testificate:" 
  for idx in 0 ..< self.cDataOptS2d[^1].len():
    var myCidxValidArr: array[cidxLim, bool]
    for cidx in CubeIdx(0) ..< cidxLim:
      #myCidxValidArr[cidx] = true
      myCidxValidArr[cidx] = tempSeq[idx][cidx]

    #for cidx in CubeIdx(0) ..< cidxLim:
    #  template rCopl: untyped = self.rCoplArr[cidx]
    #  if uint(idx) in rCopl.rCoplIdxTbl:
    #    # if we've already handled this `CubeIdx` (`cidx`)
    #    # of this specific voxel (at index `idx`),
    #    # then we don't need to handle this
    #    #echo (
    #    #  $(
    #    #    "we already handled this `idx`, `cidx`: " 
    #    #  ) & (
    #    #    $idx & " " & $cidx
    #    #  )
    #    #)
    #    myCidxValidArr[cidx] = false
    for cidx in CubeIdx(0) ..< cidxLim:
      if myCidxValidArr[cidx]:
        #echo (
        #  $(
        #    "now handling this `idx`, `cidx`: " 
        #  ) & (
        #    $idx & " " & $cidx
        #  )
        #)
        self.myFloodFill(
          idx=idx,
          cidx=cidx,
        )
      #--------

proc rectCoplsSecond(
  self: var ObjConvert
) =
  for cidx in CubeIdx(0) ..< cidxLim:
    #echo "cidx: " & $cidx
    template rCopl: untyped = self.rCoplArr[cidx]
    template rCoplMainSeq: untyped = rCopl.rCoplMainSeq
    template rCoplIdxTbl: untyped = rCopl.rCoplIdxTbl
    #template rCoplMainIdxTbl: untyped = rCopl.rCoplMainIdxTbl

    #var foundSet: HashSet[uint]

    #for outerIdx, mainIdx in rCoplIdxTbl:
    #  #--------
    #  if mainIdx in foundSet:
    #    continue
    #  foundSet.incl mainIdx
    #  #--------
    #  #--------
    #  #let cData: ptr CubeData = addr self.cDataOptS2d[^1][outerIdx]
    #  #let cInfo = addr cData.cInfoArr[cidx]
    #  #let cUnit = addr self.cUnitSeq[cInfo.unitIdx]
    #  #let quad = addr self.fSortSeq[cUnit.fIdx]
    #  #let quadVt = quad[0].v[uint(fidxVt)]

    #let chngVidx = coplCidxVidxArr[cidx]

    let chngArr = addr coplCidxVidxA2d[cidx]
    #let chngIdx = chngArr

    #let chngIdx = coplCidxVidxA2d[cidx][0]

    for mainIdx in 0 ..< rCoplMainSeq.len():
    #for outerIdx, mainIdx in rCoplIdxTbl:
      template rCoplMain: untyped = rCoplMainSeq[mainIdx]
      #if mainIdx in foundSet:
      #  continue
      #foundSet.incl mainIdx
      #let cData: ptr CubeData = addr self.cDataOptS2d[^1][outerIdx]
      #let cInfo = addr cData.cInfoArr[cidx]
      #let cUnit = addr self.cUnitSeq[cInfo.unitIdx]
      #let quad = addr self.fSortSeq[cUnit.fIdx]
      #let quadVt = quad[0].v[uint(fidxVt)]

      #template rBoundsRect: untyped = rCoplMain.rBoundsRect
      #template myBrMin: untyped = rBoundsRect[lidxMin]
      #template myBrMax: untyped = rBoundsRect[lidxMax]

      #var myS2d: seq[seq[]]
      #var dimMin: Triple[int32]
      #var dimMax: Triple[int32]
      # "Inp" as in the input to the current optimization pass
      template myInp: untyped = rCoplMain.rOutpS2d[^1]

      #for lidx in LimitIdx(0) ..< lidxLim:
      #  rBoundsRect[lidx] = [0, 0]

      #echo "mainIdx: " & $mainIdx
      #for idx in 0 ..< myInp.len():
      #  # find the bounding rectangle
      #  let quad = addr myInp[idx]
      #  echo quad[]
      #  for quadIdx in 0 ..< quad[].len():
      #    let v = addr quad[quadIdx].v
      #    for chngArrIdx in 0 ..< chngArr[].len():
      #      let chngIdx = chngArr[chngArrIdx]
      #      if v[chngIdx] < myBrMin[chngArrIdx]:
      #        myBrMin[chngArrIdx] = v[chngIdx]
      #      if v[chngIdx] > myBrMax[chngArrIdx]:
      #        myBrMax[chngArrIdx] = v[chngIdx]

      # "Outp" as in the output to the current optimization pass
      var myOutp: seq[array[quadVertArrLen, Triple[int32]]]
      #for idx in 0 ..< myInp.len():
      #  myOutp[0].add myInp[idx]
      #myInp.setLen(0)

      #myOutp[0].sort(quadVertCmp)
      #for idx in 0 ..< myOutp[0].len():
      #  myOutp[1]
      #var myMinTbl: Table[Triple[int32], Triple[uint]]
      #var myMaxTbl: Table[Triple[int32], Triple[uint]]
      #template MyLimit: untyped = array[lidxLim, Triple[int32]]

      ##var myBounds: array[lidxLim, (int32, int32)]
      #var myLimitSeq: seq[array[lidxLim, Triple[int32]]]
      ##var myLimitTbl: array[lidxLim, Triple[Table[int32, uint]]]
      #var myLimitTbl: Table[array[2, int32], uint]

      #let chngIdx = chngArr[0]
      #var myMin: array[2, int32] = [0, 0]
      #var myMax: array[2, int32] = [0, 0]
      ##var startNextStripe: bool = true
      var left: int32 = 0
      var right: int32 = 0
      var outerLeft: int32 = 0 # outer dimension counter
      var outerRight: int32 = 0 # outer dimension counter
      var prevLeft: int32 = 0
      var prevRight: int32 = 0
      var prevOuterLeft: int32 = 0 # previous outer dimension counter
      var prevOuterRight: int32 = 0 # previous outer dimension counter

      #echo "cidx, chngArr: " & $cidx & " " & $chngArr[]
      let myDim = myInp[0][0].v[chngArr[2]]

      echo "cidx, myInp.len(): " & $cidx & " " & $myInp.len()
      for idx in 0 ..< myInp.len():
        let myElem = addr myInp[idx]
        echo "front loop: " & $idx & " " & $myElem[]

      echo "post front loop"
      var didFirstStrip: bool = false
      var prevDidFirstStrip: bool = false

      proc finishStrip(
        doPrev: bool=false
      ) =
        var toAdd: array[quadVertArrLen, Triple[int32]]
        var myLeft: int32 = left
        var myRight: int32 = right
        var myOuterLeft: int32 = outerLeft
        var myOuterRight: int32 = outerRight
        var myDidFirstStrip: bool = didFirstStrip
        #var myAddend: int32 = 1

        #case cidx:
        #of cidxFront, cidxLeft, cidxBottom:
        ##if uint(cidx) mod 2 == 1:
        #  #myAddend = 1
        #  myOuterRight = myOuterLeft + 1
        #else:
        #  #myAddend = -1
        #  #myOuterLeft = myOuterRight - 1
        #myOuterRight = myOuterLeft + 1

        if doPrev:
          myLeft = prevLeft
          myRight = prevRight
          myOuterLeft = prevOuterLeft
          myOuterRight = prevOuterRight
          myDidFirstStrip = prevDidFirstStrip

        #if not myDidFirstStrip:
        #  myOuterRight = myOuterLeft + 1
        #else:
        #  myOuterLeft = myOuterRight - 1
        myOuterRight = myOuterLeft + 1

        toAdd[0].v[chngArr[0]] = myLeft
        toAdd[0].v[chngArr[1]] = myOuterLeft
        toAdd[0].v[chngArr[2]] = myDim

        toAdd[1].v[chngArr[0]] = myRight #+ 1
        toAdd[1].v[chngArr[1]] = myOuterLeft
        toAdd[1].v[chngArr[2]] = myDim

        toAdd[2].v[chngArr[0]] = myRight #+ 1
        toAdd[2].v[chngArr[1]] = myOuterRight #myOuterLeft + 1 #myAddend
        toAdd[2].v[chngArr[2]] = myDim

        toAdd[3].v[chngArr[0]] = myLeft
        toAdd[3].v[chngArr[1]] = myOuterRight #myOuterLeft + 1 #myAddend
        toAdd[3].v[chngArr[2]] = myDim
        echo toAdd

        myOutp.add toAdd

        prevDidFirstStrip = didFirstStrip

      var didFinishStrip: bool = false
      echo "chngArr: "  & $chngArr[]
      echo "myDim: " & $myDim


      for idx in 0 ..< myInp.len():
        let myElem = addr myInp[idx]

        #if dimCnt != prevDimCnt:
        #--------
        #echo (
        #  (
        #    "before: "
        #  ) & (
        #    "left:" & $left & " right:" & $right & "; "
        #  ) & (
        #    "outerLeft:" & $outerLeft & " outerRight:" & $outerRight
        #  )
        #)
        if idx == 0 or didFinishStrip:
          left = myElem[0].v[chngArr[0]]
          right = myElem[0].v[chngArr[0]]
          outerLeft = myElem[0].v[chngArr[1]]
          outerRight = myElem[0].v[chngArr[1]]

        for quadIdx in 0 ..< quadVertArrLen:
          #if quadIdx == 0:
          #  if idx == 0:
          #    left = myElem[quadIdx].v[chngArr[0]]
          #    right = myElem[quadIdx].v[chngArr[0]]
          #  else:
          #    if left > myElem[quadIdx].v[chngArr[0]]:
          #      left = myElem[quadIdx].v[chngArr[0]]
          #    if right < myElem[quadIdx].v[chngArr[0]]:
          #      right = myElem[quadIdx].v[chngArr[0]]

          #  #if (
          #  #  (
          #  #    idx == 0
          #  #  ) or (
          #  #  )
          #  #)
          #  #if idx == 0:
          #  outerLeft = myElem[quadIdx].v[chngArr[1]]
          #  outerRight = myElem[quadIdx].v[chngArr[1]]
          #else:
            #echo "quadIdx: " & $quadIdx
          #if uint(cidx) mod 2 == 0:
          case cidx:
          of cidxFront, cidxLeft, cidxBottom:
            if left > myElem[quadIdx].v[chngArr[0]]:
              left = myElem[quadIdx].v[chngArr[0]]
            if right < myElem[quadIdx].v[chngArr[0]]:
              right = myElem[quadIdx].v[chngArr[0]]

            #if outerLeft > myElem[quadIdx].v[chngArr[1]]:
            #  outerLeft = myElem[quadIdx].v[chngArr[1]]
            #if outerRight < myElem[quadIdx].v[chngArr[1]]:
            #  outerRight = myElem[quadIdx].v[chngArr[1]]
          else:
            if left < myElem[quadIdx].v[chngArr[0]]:
              left = myElem[quadIdx].v[chngArr[0]]
            if right > myElem[quadIdx].v[chngArr[0]]:
              right = myElem[quadIdx].v[chngArr[0]]

            #if outerLeft < myElem[quadIdx].v[chngArr[1]]:
            #  outerLeft = myElem[quadIdx].v[chngArr[1]]
            #if outerRight > myElem[quadIdx].v[chngArr[1]]:
            #  outerRight = myElem[quadIdx].v[chngArr[1]]
          if didFinishStrip:
            if outerLeft > myElem[quadIdx].v[chngArr[1]]:
              outerLeft = myElem[quadIdx].v[chngArr[1]]
          if outerRight < myElem[quadIdx].v[chngArr[1]]:
            outerRight = myElem[quadIdx].v[chngArr[1]]

        #if idx == 0 or didFinishStrip:
        #  prevLeft = left
        #  prevRight = right
        #  prevOuterLeft = outerLeft
        #  prevOuterRight = outerRight
            


        echo (
          #(
          #  "after: "
          #) &
          (
            "left:" & $left & " right:" & $right & "; "
          ) & (
            "outerLeft:" & $outerLeft
          ) & (
            " outerRight:" & $outerRight & ";  "
          ) & (
            " prevLeft:" & $prevLeft & " prevRight:" & $prevRight & " "
          ) & (
            " prevOuterLeft:" & $prevOuterLeft
          ) & (
            " prevOuterRight:" & $prevOuterRight
          )
        )
        #echo "main loop: " & $idx & " " & $myElem[]
        #echo $left & " " & $right & " " & $outerLeft & " " & $outerRight
          #--------
          #--------
        if (
          (
            #idx > 0
            true
          ) and (
            #outerLeft != outerRight
            #prevLeft != prevRight
            #left != right
            true
          ) and (
            #prevOuterLeft != prevOuterRight
            #outerLeft != outerRight
            true
          ) and (
            #(
            #  (
            #    outerLeft != prevOuterLeft
            #  ) and (
            #    #(uint(cidx) mod 2) == 1
            #    true
            #  )
            #)
            #or
            (
              (
                outerRight != prevOuterRight
              ) and (
                #(uint(cidx) mod 2) == 0
                true
              )
            )
          )
          #)
        ):
          echo (
            "intermediate finishStrip(): " & $cidx
          )
          didFinishStrip = true
          finishStrip(doPrev=true)
          didFirstStrip = true
        else:
          didFinishStrip = false
        prevLeft = left
        prevRight = right
        prevOuterLeft = outerLeft
        prevOuterRight = outerRight

        #if didFinishStrip:
        #  if idx + 1 < myInp.len() - 1:
        #    left = myInp[idx + 1][0].v[chngArr[0]]
        #    right = myInp[idx + 1][0].v[chngArr[0]]
        #    outerLeft = myInp[idx + 1][0].v[chngArr[1]]
        #    outerRight = myInp[idx + 1][0].v[chngArr[1]]
        #    prevLeft = left
        #    prevRight = right
        #    prevOuterLeft = outerLeft
        #    prevOuterRight = outerRight

      #if not didFinishStrip:
      echo (
        "last finishStrip(): " & $cidx
      )
      finishStrip(doPrev=true)

      #for idx in 0 ..< myLimitSeq.len():
      #  let myMin = addr myLimitSeq[idx][lidxMin]
      #  let myMax = addr myLimitSeq[idx][lidxMax]

      myInp.setLen(0)
      rCoplMain.rOutpS2d.add myOutp



proc rectCoplsThird(
  self: var ObjConvert
) =
  discard

#proc rectsSlice1d(
#  self: var ObjConvert
#) =
#  discard
#proc rectsSlice2d(
#  self: var ObjConvert
#) =
#  discard

proc rectCoplsToTris(
  self: var ObjConvert
) =
  discard

#proc doTrisToQuads(
#  self: var ObjConvert
#) =
#  discard

proc doOpt(
  self: var ObjConvert
) =
  self.maybeTrisToQuads()
  self.quadsOptFirst()
  self.quadsSort()
  self.quadsToCubes()
  self.cubesOptFirst()
  self.cubesOptSecond()
  #self.cubeFacesFindAdjCoplanar()
  #self.cubeFacesToRects()
  #self.rectsSlice1d()
  #self.rectsSlice2d()
  self.rectCoplsFirst()
  self.rectCoplsSecond()
  self.rectCoplsThird()
  self.rectCoplsToTris()
  #self.outp.add "let v = [\n"
  #for v in self.vInpSeq:
  #  self.outp.add $v
  #  self.outp.add ",\n"
  #self.outp.add "]\n"

  #self.dbgVerifyHollow()
  self.dbgVerifyRectCopl()

  for v in self.vOutpSeq:
    self.outp.add "v "
    for i in 0 ..< v.v.len():
      self.outp.add $v.v[i]
      if i + 1 < v.v.len():
        self.outp.add " "
    self.outp.add "\n"
  #self.outp.add "\n"

  for vnSeq in self.vnInpSeq:
    self.outp.add "vn "
    for i in 0 ..< vnSeq.len():
      self.outp.add $vnSeq[i]
      if i + 1 < vnSeq.len():
        self.outp.add " "
    self.outp.add "\n"
  #self.outp.add "\n"

  for vt in self.vtInpSeq:
    self.outp.add "vt "
    self.outp.add $vt[0] & " " & $vt[1]
    self.outp.add "\n"
  self.outp.add "\n"

  for fSeq in self.fOutpSeq:
    #self.outp.add " "
    self.outp.add "f "
    #for f in fSeq:
    for j in 0 ..< fSeq.len():
      #self.outp.add $f
      let f = fSeq[j]
      for i in 0 ..< f.v.len():
        self.outp.add $f.v[i]
        if i + 1 < f.v.len():
          self.outp.add "/"
      if j + 1 < fSeq.len():
        self.outp.add " "
    self.outp.add "\n"

proc doTri(
  self: var ObjConvert
) =
  discard

proc mkObjConv*(
  inputFname: string,
  mode: Mode,
  scalePow2: uint,
): ObjConvert =
  var ret: ObjConvert
  ret.mode = mode
  ret.scalePow2 = scalePow2
  ret.scale = float64(1 shl scalePow2)
  for line in inputFname.lines:
    let temp = line.splitWhitespace(1)
    if temp.len() >= 2:
      let tempSplit = temp[1].splitWhitespace()
      case temp[0]:
      of "vn":
        var toAdd: seq[float64]
        for item in tempSplit:
          toAdd.add parseFloat(item)
        ret.vnInpSeq.add toAdd
      of "vt":
        case ret.mode:
        of mdOpt:
          # --opt
          ret.vtInpSeq.add(
            (
              parseFloat(tempSplit[0]),
              parseFloat(tempSplit[1]),
            )
          )
        of mdTri:
          # --tri
          let tempY = (
            (
              uint(
                (
                  parseFloat(tempSplit[1]) #* 4
                ) * txtSubSizeY #* 16
              )
            )
          )
          let tempX = (
            uint(
              parseFloat(tempSplit[0]) * txtSubSizeX
            )
          )
          let temp = (
            uint(
              (
                (
                  tempY * txtSubSizeX
                ) + (
                  tempX
                )
              )
            )
          )
          ret.vtInpSeq.add(
            (
              float64(temp),
              float64(NaN),
            )
          )
        else:
          doAssert(
            false
          )
      of "v":
        var toAdd: Triple[int32]
        for i in 0 ..< tempSplit.len():
          toAdd.v[i] = int32(round(parseFloat(tempSplit[i])))

        ret.vInpSeq.add toAdd
      of "f":
        var toAdd: seq[Triple[uint]]
        for i in 0 ..< tempSplit.len():
          let faceSplit = tempSplit[i].split("/")
          var tempTriple: Triple[uint]
          for j in 0 ..< faceSplit.len():
            var tempUInt = parseUInt(faceSplit[j])
            if ret.mode == mdTri:
              tempUInt -= 1
            tempTriple.v[j] = tempUInt
          toAdd.add tempTriple
        ret.fInpSeq.add toAdd
      else:
        if ret.mode != mdTri:
          ret.outp.add line & "\n"
  case ret.mode:
  of mdOpt:
    ret.doOpt()
  of mdTri:
    ret.doTri()
  else:
    doAssert(
      false
    )
  result = ret
