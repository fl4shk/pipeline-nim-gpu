#import std/macros
import std/strutils
#import std/tables
import std/cmdline
import std/math
#import std/streams
import objConv
import palConv
import mode

let paramsSeq = commandLineParams()

proc usage() =
  echo "Usage 0: modelConv --opt input.obj output.obj"
  echo "Usage 1: modelConv --tri fixedPtScalePow2 input.obj output.nim"
  echo "Usage 2: modelConv --pal input.png output.nim"
  doAssert(false)



var myMode: Mode

var scalePow2: uint = 0
#var scale: float64 = 0.0
var inputFname: string
var outputFname: string

if paramsSeq.len() == 3:
  inputFname = paramsSeq[1]
  outputFname = paramsSeq[2]
  case paramsSeq[0]:
  of "--opt":
    myMode = mdOpt
  of "--pal":
    myMode = mdPal
  else:
    usage()
elif paramsSeq.len() == 4:
  if paramsSeq[0] == "--tri":
    myMode = mdTri
    scalePow2 = parseUInt(paramsSeq[1])
    #scale = float64(1 shl scalePow2)
    inputFname = paramsSeq[2]
    outputFname = paramsSeq[3]
  else:
    usage()
else:
  usage()

case myMode:
of mdOpt, mdTri:
  let oconv = mkObjConv(
    inputFname=inputFname,
    mode=myMode,
    scalePow2=scalePow2,
  )
  writeFile(filename=outputFname, content=oconv.outp)
of mdPal:
  let pconv = mkPalConv(
    inputFname=inputFname,
  )
  writeFile(filename=outputFname, content=pconv.outp)
