#import std/macros
import std/strutils
#import std/tables
import std/cmdline
import std/math
#import std/streams
import objConv
import palConv
import mode

#var inpFile: File = 
#proc eatWhitespace(
#):

#let scalePow2 = 8
#let scale = float64(1 shl scalePow2)



#var objConv: Convert
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

#var oconv: ObjConvert
#var pconv: PalConv

case myMode:
of mdOpt, mdTri:
  let oconv = mkObjConv(
    inputFname=inputFname,
    #isTri=(myMode == mdTri),
    mode=myMode,
    scalePow2=scalePow2,
  )
  writeFile(filename=outputFname, content=oconv.outp)
#of mdTri:
#  oconv = mkObjConv(
#    inputFname=inputFname,
#    isTri=true,
#    scalePow2=scalePow2,
#  )
of mdPal:
  let pconv = mkPalConv(
    inputFname=inputFname,
  )
  writeFile(filename=outputFname, content=pconv.outp)

#let input = readFile(paramsSeq[1])
#var outp: string

#var inpFile: File
#for line in stdin.lines:

#outp.add "let v = [\n"
#for v in conv.vInpSeq:
#  outp.add "  "
#  outp.add $v
#  outp.add ",\n"
#outp.add "]\n\n"

#outp.add "let vt = [\n"
#for vt in conv.vtInpSeq:
#  outp.add "  "
#  outp.add $vt
#  outp.add ",\n"
#outp.add "]\n\n"

#outp.add "let vn = [\n"
#for vn in conv.vnInpSeq:
#  outp.add "  "
#  outp.add $vn
#  outp.add ",\n"
#outp.add "]\n\n"
#
#outp.add "let f = [\n"
#for f in conv.fInpSeq:
#  outp.add "  "
#  outp.add $f
#  outp.add ",\n"
#outp.add "]\n"

#case myMode:
#of mdOpt, mdTri:
#of mdPal:
