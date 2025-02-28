import std/strutils
import std/tables
#import std/cmdline
import std/math
import miscMath
import mode
import std/sets

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
    rcidx*: ReducedCubeIdx
    cidx*: CubeIdx
    n*: array[quadVertArrLen, Triple[int32]] # normalized
    fIdx*: int

proc isAdj*(
  left: CubeUnit,
  right: CubeUnit,
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
  CubeData* = object
    c*: Cube
    cUnitIdxSeq*: seq[uint]

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

type
  CubeIdxInfo* = object
    unitIdx*: uint
    cidx*: CubeIdx

proc toCubeIdxInfoTbl(
  #cube: Cube,
  #cData: CubeData,
  #c: Cube,
  #vArr: array[quadVertArrLen, Triple[int32]]
  #cidx: CubeIdx,
  #idx: int,
  cUnitSeq: ptr seq[CubeUnit],
  cData: ptr CubeData,
  #cUnit: CubeUnit,
): Table[CubeIdx, CubeIdxInfo] =
  #var vSet: HashSet[Triple[int32]]
  #for v in vArr:
  #  vSet.incl(v - vArr[0])


  #for j in 0 ..< cUnitSeq[].len():
  #for j in 0 ..< cData.cUnitIdxSeq.len():
  #  let unit: ptr CubeUnit = addr cUnitSeq[][cData.cUnitIdxSeq[j]]
  var myRciTbl: Table[
    #ReducedCubeIdx, seq[(uint, bool)]
    ReducedCubeIdx, seq[CubeIdxInfo]
  ]
  for unitIdx in cData.cUnitIdxSeq:
    let unit: ptr CubeUnit = addr cUnitSeq[unitIdx]
    var myInpCidx: CubeIdx
    case unit.rcidx:
    of rcidxFront:
      myInpCidx = cidxFront
    of rcidxLeft:
      myInpCidx = cidxLeft
    of rcidxBottom:
      myInpCidx = cidxBottom
    else:
      doAssert(false)

    if unit.rcidx notin myRciTbl:
      myRciTbl[unit.rcidx] = @[CubeIdxInfo(
        unitIdx: unitIdx,
        cidx: myInpCidx,
      )]
    else:
      let mySeq = addr myRciTbl[unit.rcidx]
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
          continue

        if vSub[0].v.contains(-1): # they should all be identical
          haveNeg = true
        var myCidx: array[2, CubeIdx]

        case unit.rcidx:
        of rcidxFront:
          myCidx = [cidxFront, cidxBack]
        of rcidxLeft:
          myCidx = [cidxLeft, cidxRight]
        of rcidxBottom:
          myCidx = [cidxBottom, cidxTop]
        else:
          doAssert(false)
        var toAdd = CubeIdxInfo(
          unitIdx: unitIdx,
          cidx: myCidx[1],
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
    for item in v:
      result[item.cidx] = item

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
    vUnitTbl*: Table[Triple[int32], seq[uint]]

    ## `cfTbl` maps from each quad's `CubeUnit` to a (potential) pair of
    ## `Cube`s
    #cfTbl*: Table[uint, array[2, uint]]
    #cfTbl*: Table[Triple[int32], array[rcidxLim, (bool, uint)]]
    #cvTbl*: Table[Triple[int32], seq[uint]]
    #cNormTbl*: Table[array[cidxLim, uint], seq[uint]]
    #cvTbl*: Table[uint, seq[uint]]
    #hqSeq*: seq[array[2, uint]] # half-quad `seq`
    #cPartSeq*: seq[Cube]
    cDataIdxTbl*: Table[HashSet[Triple[int32]], uint]
    cDataInpSeq*: seq[CubeData] #seq[(Cube, seq[uint])]
    cDataOptSeq*: seq[CubeData]
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
    self.fQuadSeq = move(self.fInpSeq)
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
        unit.rcidx = rcidxFront
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
        unit.rcidx = rcidxLeft
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
        unit.rcidx = rcidxBottom
    else:
      doAssert(
        false
      )
  doAssert(
    foundRci
  )
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
    let unit = mkCubeUnit(
      vSeq=self.vOptSeq,
      fSeq=fSeq,
      fIdx=j,
    )
    #if unit.rcidx == rcidxFront:
    for i in 0 ..< unit.vArr.len():
      let v = unit.vArr[i]
      if v notin self.vUnitTbl:
        self.vUnitTbl[v] = @[]
      doAssert(
        uint(self.cUnitSeq.len()).notin self.vUnitTbl[v]
      )
      self.vUnitTbl[v].add uint(self.cUnitSeq.len())
    self.cUnitSeq.add unit
  #for k, v in self.vNormTbl:
  #  echo $k & ": " & $v

  #var cvTbl: Table[]

  #var cDataIdxTbl: Table[HashSet[Triple[int32]], uint]
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
      case unit.rcidx:
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
        if vOffsArr[k][i].notin self.vUnitTbl:
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
  for j in 0 ..< self.cDataInpSeq.len():
    let cData = addr self.cDataInpSeq[j]

    #var myCiTbl: Table[CubeIdx, seq[(uint, CubeFaceKind)]]
    let cIdxInfoTbl = toCubeIdxInfoTbl(
      cUnitSeq=addr self.cUnitSeq,
      cData=cData,
    )

    var toAdd = CubeData(
      c: cData.c
    )
    self.cDataOptSeq.add toAdd

  self.cDataInpSeq.setLen(0)

proc cubesToRects(
  self: var ObjConvert
) = 
  discard
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
  self.cubesToRects()
  self.rectsToTris()
  #self.outp.add "let v = [\n"
  #for v in self.vInpSeq:
  #  self.outp.add $v
  #  self.outp.add ",\n"
  #self.outp.add "]\n"

  # step 1: if two cubes are directly beside each other, don't draw the
  # faces between them
  # step 2: if all faces in a vertex are removed by the above rule, delete
  # the vertex too
  # done

  for v in self.vOptSeq:
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
  #isTri: bool,
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
        #ret.vnInpSeq.add tempSplit
        #ret.vnInpSeq.add(seq[float64])
        var toAdd: seq[float64]
        for item in tempSplit:
          toAdd.add parseFloat(item)
        ret.vnInpSeq.add toAdd
      of "vt":
        #if not isTri:
        case ret.mode:
        #of mdTrisToQuads, mdOpt:
        of mdOpt:
          # --tri-to-quad, --quad
          ret.vtInpSeq.add(
            (
              parseFloat(tempSplit[0]),
              parseFloat(tempSplit[1]),
            )
          )
        of mdTri:
          # --tri
          #ret.vtInpSeq.add tempSplit
          #var toAdd: seq[uint]
          #for item in tempSplit:
          #  toAdd.add parseUInt(item)
          let tempY = (
            (
              uint(
                (
                  parseFloat(tempSplit[1]) #* 4
                ) * txtSubSizeY #* 16
              ) #div 4
            ) #- 1
          )
          let tempX = (
            uint(
              #parseFloat(tempSplit[0]) * 4 #* 16
              #parseFloat(tempSplit[0]) #* 16
              parseFloat(tempSplit[0]) * txtSubSizeX
            ) #div 4
          )
          let temp = (
            uint(
              (
                (
                  tempY * txtSubSizeX
                ) + (
                  tempX
                )
              ) #/ 16
              #/ (
              #  4
              #)
            )
          )
          #ret.outp.add "("
          #ret.outp.add $tempY
          #ret.outp.add ", "
          #ret.outp.add $tempX
          #ret.outp.add ") -> "
          #ret.outp.add $temp
          #ret.outp.add "\n"
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
        #ret.vInpSeq.add tempSplit
        #var toAdd: seq[float64]
        #for item in tempSplit:
        #  toAdd.add parseFloat(item)
        #ret.vInpSeq.add Vert(
        #  v: [
        #    toAdd[0],
        #    toAdd[1],
        #    toAdd[2],
        #  ]
        #)
        var toAdd: Triple[int32]
        for i in 0 ..< tempSplit.len():
          toAdd.v[i] = int32(round(parseFloat(tempSplit[i])))

        #if toAdd notin ret.vTbl:
        #  ret.vTbl[toAdd] = @[]
        #ret.vTbl[toAdd].add uint(ret.vInpSeq.len())

        ret.vInpSeq.add toAdd
      of "f":
        #var toAdd: seq[FaceElem]
        #ret.fInpSeq.add temp[1].splitWhitespace()

        #for item in tempSplit:
        #  let faceSplit = item.split("/")
        #  toAdd.add FaceElem(
        #    vIdx: parseUInt(faceSplit[0]),
        #    vtIdx: parseUInt(faceSplit[1]),
        #    vnIdx: parseUInt(faceSplit[2]),
        #  )
        #ret.fInpSeq.add toAdd
        var toAdd: seq[Triple[uint]]
        for i in 0 ..< tempSplit.len():
          let faceSplit = tempSplit[i].split("/")
          var tempTriple: Triple[uint]
          for j in 0 ..< faceSplit.len():
            #toAdd.v[i].v[j] = parseUInt(faceSplit[j]) - 1
            #toAdd.v[i].add parseUInt(faceSplit[j]) - 1
            var tempUInt = parseUInt(faceSplit[j])
            #if isTri:
            if ret.mode == mdTri:
              tempUInt -= 1
            tempTriple.v[j] = tempUInt
          toAdd.add tempTriple
        ret.fInpSeq.add toAdd
      else:
        #if not isTri:
        if ret.mode != mdTri:
          ret.outp.add line & "\n"
  #if not ret.isTri:
  case ret.mode:
  #of mdTrisToQuads:
  #  ret.doTrisToQuads()
  of mdOpt:
    ret.doOpt()
  of mdTri:
    ret.doTri()
  else:
    doAssert(
      false
    )
  result = ret
