import std/strutils
import std/tables
#import std/cmdline
import std/math
import miscMath
import mode
import std/sets
import std/options

type 
  Triple*[T] = object
    #x*: float64
    #y*: float64
    #z*: float64
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
  
type
  ReducedCubeIdx* = enum
    rcidxFront,
    rcidxLeft,
    rcidxBottom,
    rcidxLim,

#type
#  CubeFace* = object
#    #valid*: bool
#    cnIdx*: uint # CubeUnit index


const
  quadVertArrLen* = 4
  cubeNumVerts* = 8
  #cubeOrderTriA2dLen* = 2
  #cubeOrderTriArrLen* = 3
  #cubeTriArrLen* = 2
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
    vArr*: array[quadVertArrLen, Triple[int32]]
    rcidx*: Option[ReducedCubeIdx]
    cidx*: Option[CubeIdx]
    n*: array[quadVertArrLen, Triple[int32]] # normalized
    fIdx*: int
var vnConvArr: array[rcidxLim, array[2, uint]]

proc isAdjSide*(
  left: ptr CubeUnit,
  right: ptr CubeUnit,
): bool =
  let vLeftSet = toHashSet(left.vArr)
  let vRightSet = toHashSet(right.vArr)
  result = (vLeftSet == vRightSet)

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
    unitIdx*: uint
    cidx*: Option[CubeIdx]

type
  CubeData* = object
    c*: Cube
    cUnitIdxSeq*: seq[uint]
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
  #cube: Cube,
  #cData: CubeData,
  #c: Cube,
  #vArr: array[quadVertArrLen, Triple[int32]]
  #cidx: CubeIdx,
  #idx: int,
  cUnitSeq: ptr seq[CubeUnit],
  cData: ptr CubeData,
  #cUnit: CubeUnit,
): array[cidxLim, CubeDataInfo] =
  #var vSet: HashSet[Triple[int32]]
  #for v in vArr:
  #  vSet.incl(v - vArr[0])


  #for j in 0 ..< cUnitSeq[].len():
  #for j in 0 ..< cData.cUnitIdxSeq.len():
  #  let unit: ptr CubeUnit = addr cUnitSeq[][cData.cUnitIdxSeq[j]]
  var myRciTbl: Table[
    #ReducedCubeIdx, seq[(uint, bool)]
    ReducedCubeIdx, seq[CubeDataInfo]
  ]
  for unitIdx in cData.cUnitIdxSeq:
    let unit: ptr CubeUnit = addr cUnitSeq[unitIdx]
    #echo "unit[]: " & $unit[]
    var myInpCidx: CubeIdx
    doAssert(
      unit.rcidx.isSome
    )
    case unit.rcidx.get():
    of rcidxFront:
      myInpCidx = cidxFront
    of rcidxLeft:
      myInpCidx = cidxLeft
    of rcidxBottom:
      myInpCidx = cidxBottom
    else:
      doAssert(false)

    if unit.rcidx.get() notin myRciTbl:
      myRciTbl[unit.rcidx.get()] = @[CubeDataInfo(
        unitIdx: unitIdx,
        cidx: some(myInpCidx),
      )]
    else:
      let mySeq = addr myRciTbl[unit.rcidx.get()]
      if mySeq[].len() == 1:
      #for i in 0 ..< mySeq[].len():
        let info = mySeq[0]
        let otherUnit = addr cUnitSeq[info.unitIdx]
        var vSub: array[quadVertArrLen, Triple[int32]]
        #var mySum: int32 = 0
        var haveNeg: bool = false
        for i in 0 ..< vSub.len():
          vSub[i] = unit.vArr[i] - otherUnit.vArr[i]

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

        case unit.rcidx.get():
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

#proc findCubeSide(
#): CubeOrder

#type
#  CubeFaceKind* = enum
#    cfkUnknown,
#    cfkZero,
#    cfkOne,
type
  RectData = object
    rSeq*: seq[array[quadVertArrLen, Triple[int32]]] # rect `seq`
    rIdxTbl*: Table[Triple[int32], seq[uint]] # vert to `rSeq` index

type
  ObjConvert* = object
    #cmdSeq*: seq[string]
    vnInpSeq*: seq[seq[float64]]
    #vnOutpSeq*: seq[seq[float64]]
    #vnTbl*: Table[Vert, bool]
    vtInpSeq*: seq[(float64, float64)]
    #vtOutpSeq*: seq[seq[uint]]
    #vtTbl*: Table[VertUv, bool]
    vInpSeq*: seq[Triple[int32]]
    vOptSeq*: seq[Triple[int32]]
    vOutpSeq*: seq[Triple[int32]]
    # unlikely to have more than a small handful
    #vTbl*: Table[Triple[int32], seq[uint]]
    fInpSeq*: seq[seq[Triple[uint]]]
    fQuadSeq*: seq[seq[Triple[uint]]]
    fOptSeq*: seq[seq[Triple[uint]]]
    fSortSeq*: seq[seq[Triple[uint]]]
    fOutpSeq*: seq[seq[Triple[uint]]]
    #fTbl: Table[array[3, FaceElem], bool]
    #fInpSeq*: seq[array[3, FaceElem]]
    #cTbl*: Table[uint, Cube] # maps `vtIdx` to `Cube`

    # maps from an index into `fInpSeq` to `seq` of indices into `cSeq`
    # (`seq[uint]` in case the input `.obj` has faces shared by multiple
    # `Cube`s)
    #cfPairTbl*: Table[uint, array[2, uint]]

    cUnitSeq*: seq[CubeUnit]
    vUnitInpTbl*: Table[Triple[int32], seq[uint]]
    vUnitOptTbl*: Table[Triple[int32], seq[uint]]

    cDataIdxTbl*: Table[HashSet[Triple[int32]], uint]
    cDataInpSeq*: seq[CubeData] #seq[(Cube, seq[uint])]
    #cDataOptArrSeq*: seq[array[cidxLim, seq[uint]]]
    cDataOptS2d*: seq[seq[CubeData]]
    cDataAdjS2d*: seq[seq[array[cidxLim, seq[uint]]]]
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
      let tempSwap = maxDistPair[0]
      maxDistPair[0] = maxDistPair[1]
      maxDistPair[1] = tempSwap

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
    let tempSwap = sorted[2]
    sorted[2] = sorted[3]
    sorted[3] = tempSwap
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
  var unit: CubeUnit
  unit.fIdx = fIdx
  for i in 0 ..< unit.vArr.len():
    unit.vArr[i] = vSeq[fSeq[i].v[uint(fidxV)] - 1]
    unit.n[i] = unit.vArr[i] - unit.vArr[0]
    #for j in 0 ..< unit.n[i].v.len():
    #  unit.n[i].v[j] = unit.vArr[i].v[j] - unit.vArr[0].v[j]

  var foundRci: bool = false
  for rcidx in rcidxFront ..< rcidxLim:
    case rcidx:
    of rcidxFront:
      var myFoundRci: bool = true
      for i in 0 ..< unit.n.len():
        if unit.n[i].v != cubeOrderA2d[cidxFront].c[i].v:
          myFoundRci = false
      if myFoundRci:
        foundRci = true
        unit.rcidx = some(rcidxFront)
    of rcidxLeft:
      var myFoundRci: bool = true
      for i in 0 ..< unit.n.len():
        if unit.n[i].v != cubeOrderA2d[cidxLeft].c[i].v:
          myFoundRci = false
      if foundRci:
        doAssert(
          not myFoundRci
        )
      elif myFoundRci:
        foundRci = true
        unit.rcidx = some(rcidxLeft)
    of rcidxBottom:
      var myFoundRci: bool = true
      for i in 0 ..< unit.n.len():
        if unit.n[i].v != cubeOrderA2d[cidxBottom].c[i].v:
          myFoundRci = false
      if foundRci:
        doAssert(
          not myFoundRci
        )
      elif myFoundRci:
        foundRci = true
        unit.rcidx = some(rcidxBottom)
    else:
      doAssert(false)
  doAssert(foundRci)

  #case unit.rcidx.get():
  #of rcidxFront:
  #  vnConvArr[unit.rcidx.get()][0] = (
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
      vnConvArr[unit.rcidx.get()][0] = vnIdx
    elif round(vn[i]) == -1:
      doAssert(not foundVn)
      foundVn = true
      vnConvArr[unit.rcidx.get()][1] = vnIdx
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
  result = unit

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

  for j in 0 ..< self.fSortSeq.len():
    let fSeq = self.fSortSeq[j]
    let unit = self.mkCubeUnit(
      vSeq=self.vOptSeq,
      fSeq=fSeq,
      fIdx=j,
    )
    #if unit.rcidx == rcidxFront:
    for i in 0 ..< unit.vArr.len():
      let v = unit.vArr[i]
      if v notin self.vUnitInpTbl:
        self.vUnitInpTbl[v] = @[]
      doAssert(
        uint(self.cUnitSeq.len()).notin self.vUnitInpTbl[v]
      )
      self.vUnitInpTbl[v].add uint(self.cUnitSeq.len())
    self.cUnitSeq.add unit
  #for k, v in self.vNormTbl:
  #  echo $k & ": " & $v

  #var cvTbl: Table[]

  #var cDataIdxTbl: Table[HashSet[Triple[int32]], uint]
  #echo self.cUnitSeq.len()
  for j in 0 ..< self.cUnitSeq.len():
    let unit = self.cUnitSeq[j]
    #if unit.rcidx == rcidxFront:
    const
      tempLen = 2
    var cube: array[tempLen, Cube]
    var found: array[tempLen, bool] = [true, true]
    var vOffsArr: array[tempLen, array[quadVertArrLen, Triple[int32]]]
    for i in 0 ..< unit.vArr.len():
      let v = unit.vArr[i]
      for k in 0 ..< tempLen:
        vOffsArr[k][i].v[0] = v.v[0]
        vOffsArr[k][i].v[1] = v.v[1]
        vOffsArr[k][i].v[2] = v.v[2]
      doAssert(
        unit.rcidx.isSome
      )
      case unit.rcidx.get():
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

      #case unit.rcidx:
      #of rcidxFront:
      cube[0].c[i] = v
      cube[0].c[i + unit.vArr.len()] = vOffsArr[0][i]
      cube[1].c[i + unit.vArr.len()] = v
      cube[1].c[i] = vOffsArr[1][i]
      #else:
      #  cube[0].c[i] = Triple[int32](v: [0, 0, 0])
      #  cube[0].c[i + unit.vArr.len()] = Triple[int32](v: [0, 0, 0])
      #  cube[1].c[i + unit.vArr.len()] = Triple[int32](v: [0, 0, 0])
      #  cube[1].c[i] = Triple[int32](v: [0, 0, 0])

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
          #echo "cSet.notin cDataIdxTbl: " & $j
          self.cDataIdxTbl[cSet] = uint(self.cDataInpSeq.len())
          self.cDataInpSeq.add CubeData(
            c: cube[k].cubeVertSort(),
            cUnitIdxSeq: @[uint(j)],
          )
          #var s: string
          #s.add " -- "
          #echo $cube[k].c
          #echo ""
          #self.cSeq.add cube[k]
        else:
          #echo "cSet.contains cDataIdxTbl: " & $j
          let cDataIdx = self.cDataIdxTbl[cSet]
          let cData = addr self.cDataInpSeq[cDataIdx]
          doAssert(
            uint(j).notin cData.cUnitIdxSeq
          )
          cData.cUnitIdxSeq.add uint(j)
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

    #var myCiTbl: Table[CubeIdx, seq[(uint, CubeFaceKind)]]
    #var mySet: HashSet[CubeIdx]
    let cInfoArr = toCubeDataInfoArr(
      cUnitSeq=addr self.cUnitSeq,
      cData=cData,
    )
    var doIt: bool = true
    for cidx in CubeIdx(0) ..< cidxLim:
      if not cInfoArr[cidx].cidx.isSome:
        doIt = false
    #if mySet.len() == int(cidxLim):
    if doIt:
      var toAdd = CubeData(
        c: cData.c,
        cInfoArr: cInfoArr,
      )
      #for cInfo in toAdd.cInfoArr:
      #  toAddArr[cInfo.cidx].add (uint(j), cInfo.unitIdx)

      self.cDataOptS2d[0].add toAdd
  #for j in 0 ..< self.cDataOptS2d[0].len():
  #  let cData = addr self.cDataOptS2d[0][j]
  #  for cInfo in cData.cInfoArr:
  #    toAddArr[cInfo.cidx].add uint(j) #cInfo.unitIdx

  #for j in 0 ..< self.cDataOptS2d[0].len():
  #  let cData = addr self.cDataInpSeq[j]
  #  #for cidx in CubeIdx(0) ..< cidxLim:
  #  #  toAddArr[cidx].add 
  #self.cDataOptArrSeq.add toAddArr

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

  #proc innerFunc(
  #  self: var ObjConvert,
  #  cData0: var CubeData,
  #  cData1: var CubeData,
  #) =
  #  #let currSeq = addr self.cDataOptS2d[^1]
  #  #let a = addr currSeq
  #  for cInfo0 in cData0.cInfoArr:
  #    let cInfo1 = addr cData1.cInfoArr[revCubeIdx(cInfo0.cidx)]
  #    let cUnit0 = addr self.cUnitSeq[cInfo0.unitIdx]
  #    let cUnit1 = addr self.cUnitSeq[cInfo1.unitIdx]
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
          doAssert(
            false
          )
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
        #self.innerFunc(
        #  cData0=cData0[],
        #  cData1=cData1[],
        #)
        if int(i) != j:
          #for cInfo0 in cData0.cInfoArr:
          for k in CubeIdx(0) ..< cidxLim:
            let cInfo0 = cData0.cInfoArr[k]
            if not cInfo0.cidx.isSome:
              echo $k 
            doAssert(
              cInfo0.cidx.isSome
            )
            let cInfo1 = (
              addr cData1.cInfoArr[revCubeIdx(cInfo0.cidx.get()) ]
            )
            let cUnit0 = addr self.cUnitSeq[cInfo0.unitIdx]
            let cUnit1 = addr self.cUnitSeq[cInfo1.unitIdx]
            if isAdjSide(left=cUnit0, right=cUnit1):
              ##var s: string
              #echo "have adjacent side: " & $i
              #echo $cInfo0.cidx & " " & $cInfo1.cidx
              #echo cUnit0.vArr
              #echo cUnit1.vArr
              #echo ""
              toAdd[cInfo0.cidx.get()].add i
      #for cInfo in cData.cInfoArr:
      #  let revCidx = revCubeIdx(cidx=cInfo.cidx)
    #echo "----"
    result.add toAdd
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
    #if cData
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
  #myTbl.clear()
  #--------
  ## BEGIN: old debug way to verify that we successfully hollowed out the
  ## voxel model!
  #var myVertTbl: Table[Triple[int32], uint]
  #for j in 0 ..< self.cDataOptS2d[^1].len():
  #  let cData: ptr CubeData = addr self.cDataOptS2d[^1][j]
  #  #let myAdj = addr 
  #  for cidx in CubeIdx(0) ..< cidxLim:
  #    let adjSeq = addr adjSeq[j][cidx]
  #    if adjSeq[].len() > 0:
  #      discard
  #    else:
  #      #echo $j & ": " & $cidx & " " & $cData.c.c
  #      let cInfo = addr cData.cInfoArr[cidx]
  #      let unit: ptr CubeUnit = addr self.cUnitSeq[cInfo.unitIdx]
  #      let quad = addr self.fSortSeq[unit.fIdx]
  #      var fSeq: seq[Triple[uint]]
  #      var vnIdx: uint = 0

  #      case cidx:
  #      of cidxFront:
  #        vnIdx = vnConvArr[rcidxFront][0]
  #      of cidxBack:
  #        vnIdx = vnConvArr[rcidxFront][1]
  #      of cidxLeft:
  #        vnIdx = vnConvArr[rcidxLeft][0]
  #      of cidxRight:
  #        vnIdx = vnConvArr[rcidxLeft][1]
  #      of cidxBottom:
  #        vnIdx = vnConvArr[rcidxBottom][0]
  #      of cidxTop:
  #        vnIdx = vnConvArr[rcidxBottom][1]
  #      else:
  #        discard

  #      for i in 0 ..< quadVertArrLen:
  #        let v = unit.vArr[i]
  #        var fTemp: Triple[uint]
  #        #self.vOutpSeq
  #        var vSeqIdx: uint = 0

  #        if v notin myVertTbl:
  #          vSeqIdx = uint(self.vOutpSeq.len())
  #          self.vOutpSeq.add v
  #        else:
  #          vSeqIdx = myVertTbl[v]
  #        fTemp.v[uint(fidxV)] = vSeqIdx + 1
  #        #for k in 0 ..< quadVertArrLen:
  #        fTemp.v[uint(fidxVt)] = quad[0].v[uint(fidxVt)]
  #        #fTemp.v[uint(fidxVn)] = quad[0].v[uint(fidxVn)]
  #        fTemp.v[uint(fidxVn)] = vnIdx
  #        fSeq.add fTemp
  #      case cidx:
  #      of cidxBack, cidxRight, cidxBottom:
  #        self.fOutpSeq.add fSeq
  #      of cidxFront, cidxLeft, cidxTop:
  #        var tempFSeq: seq[Triple[uint]]
  #        var i: int = quadVertArrLen - 1
  #        while i >= 0:
  #          tempFSeq.add fSeq[i]
  #          i -= 1
  #        self.fOutpSeq.add tempFSeq
  #      else:
  #        discard
  ## END: old debug way to verify that we successfully hollowed out the
  ## voxel model!
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

proc cubesToRects(
  self: var ObjConvert
) = 
  #var myVertTbl: Table[Triple[int32], uint]
  #var myVertTbl: Table[Triple[int32], uint]
  var rDataArr: array[
    cidxLim,
    #Table[Triple[int32], uint],
    RectData
  ]
  let adjSeq = addr self.cDataAdjS2d[^1]
  for j in 0 ..< self.cDataOptS2d[^1].len():
    let cData: ptr CubeData = addr self.cDataOptS2d[^1][j]
    #let myAdj = addr 
    for cidx in CubeIdx(0) ..< cidxLim:
      #var rcidx: ReducedCubeIdx
      #case cidx:
      #of cidxFront, cidxBack:
      #  rcidx = rcidxFront
      #of cidxLeft, cidxRight:
      #  rcidx = rcidxLeft
      #of cidxBottom, cidxTop:
      #  rcidx = rcidxBottom
      #else:
      #  doAssert(false)

      let rData = addr rDataArr[cidx]

      let adjSeq = addr adjSeq[j][cidx]
      if adjSeq[].len() > 0:
        discard
      else:
        discard
        ##echo $j & ": " & $cidx & " " & $cData.c.c
        #let cInfo = addr cData.cInfoArr[cidx]
        #let unit: ptr CubeUnit = addr self.cUnitSeq[cInfo.unitIdx]
        #let quad = addr self.fSortSeq[unit.fIdx]
        #var fSeq: seq[Triple[uint]]
        #var vnIdx: uint = 0

        #case cidx:
        #of cidxFront:
        #  vnIdx = vnConvArr[rcidxFront][0]
        #of cidxBack:
        #  vnIdx = vnConvArr[rcidxFront][1]
        #of cidxLeft:
        #  vnIdx = vnConvArr[rcidxLeft][0]
        #of cidxRight:
        #  vnIdx = vnConvArr[rcidxLeft][1]
        #of cidxBottom:
        #  vnIdx = vnConvArr[rcidxBottom][0]
        #of cidxTop:
        #  vnIdx = vnConvArr[rcidxBottom][1]
        #else:
        #  discard

proc rectsToTris(
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
  self.cubesToRects()
  self.rectsToTris()
  #self.outp.add "let v = [\n"
  #for v in self.vInpSeq:
  #  self.outp.add $v
  #  self.outp.add ",\n"
  #self.outp.add "]\n"

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
  #ret.isTri = isTri
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
