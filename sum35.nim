import times, os, strutils, std/monotimes

proc sum35A*(n: uint): uint =
  for i in 0'u ..< n:
    if i mod 3 == 0 or i mod 5 == 0:
      result += i

proc sum35B*(n: uint): uint =
  for i in 0'u ..< n:
    if i mod 15 in {0, 3, 5, 6, 9, 10, 12}:
      result += i

proc sum35D*(n: uint): uint =
  for i in 0'u ..< n:
    if i mod 15 in [0'u, 3, 5, 6, 9, 10, 12]:
      result += i

proc sumMults(first: uint, limit: uint): uint =
  var last = limit - 1
  last -= last mod first
  result = last + first
  if (result and 1) == 0:
    result = result div 2 * (last div first)
  else:
    result *= (last div first) div 2

proc sum35C*(n: uint): uint =
  sumMults(3, n) + sumMults(5, n) - sumMults(15, n)

let n = paramStr(1).parseUInt
#let n = 8891427027'u # maximum value where the result fits in an uint64

let start1 = epochTime(); let start1a = getTime(); let start1b = getMonoTime()
let r1 = sum35A(n)
let stop1 = epochTime(); let stop1a = getTime(); let stop1b = getMonoTime()
let start2 = epochTime(); let start2a = getTime(); let start2b = getMonoTime()
let r2 = sum35B(n)
let stop2 = epochTime(); let stop2a = getTime(); let stop2b = getMonoTime()
let start3 = epochTime(); let start3a = getTime(); let start3b = getMonoTime()
let r3 = sum35C(n)
let stop3 = epochTime(); let stop3a = getTime(); let stop3b = getMonoTime()
let start4 = epochTime(); let start4a = getTime(); let start4b = getMonoTime()
let r4 = sum35D(n)
let stop4 = epochTime(); let stop4a = getTime(); let stop4b = getMonoTime()

echo r1, "\n ", stop1-start1, "\n ", stop1a-start1a, "\n ", stop1b-start1b
echo r2, "\n ", stop2-start2, "\n ", stop2a-start2a, "\n ", stop2b-start2b
echo r3, "\n ", stop3-start3, "\n ", stop3a-start3a, "\n ", stop3b-start3b
echo r4, "\n ", stop4-start4, "\n ", stop4a-start4a, "\n ", stop4b-start4b
echo uint.high
