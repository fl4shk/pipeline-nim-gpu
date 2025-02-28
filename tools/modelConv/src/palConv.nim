import pixie
import miscMath
import std/strutils

type
  PalConv* = object
    outp*: string

proc mkPalConv*(
  inputFname: string
): PalConv =
  var img = readImage(inputFname) 

  result.outp.add "[\n" 
  for j in 0 ..< img.height:
    for i in 0 ..< img.width:
      if (
        (
          j mod pxSubSizeY == 0x0
        ) and (
          i mod pxSubSizeX == 0x0
        )
      ):
        var rgbx = img.unsafe[i, j]
        let color = rgbx.color().asRgb
        result.outp.add "  "
        #result.outp.add color
        var toAdd: uint16 = 0
        #toAdd = (toAdd shl 5) or 
        toAdd = toAdd or (color.b and 0x1f)
        toAdd = (toAdd shl 5) or (color.g and 0x1f)
        toAdd = (toAdd shl 5) or (color.r and 0x1f)
        result.outp.add "0x"
        result.outp.add toHex(toAdd)
        result.outp.add ",\n"
        #result.outp.add 
  result.outp.add "]\n"
