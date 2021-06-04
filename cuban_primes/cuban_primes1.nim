import std/[strformat, strutils]
import std/math

const
  cutOff = 200
  bigUn = 100000
  chunks = 50
  little = bigUn div chunks

echo fmt"The first {cutOff} cuban primes"
var
  c, u = 0
  showEach = true
  v = 1
var primes: seq[int] = @[3, 5]

for i in 1..high(BiggestInt):
  inc u, 6
  inc v, u
  var
    found: bool
    mx = int(ceil(sqrt(float(v))))
  for item in primes:
    if item > mx:
      break
    if v mod item == 0:
      found = true
      break
  if found:
    continue
  inc c
  if showEach:
    for z in countup(primes[^1] + 2, v - 2, step=2):
      var fnd = false
      for item in primes:
        if item > mx:
          break
        if z mod item == 0:
          fnd = true
          break
      if not fnd:
        primes.add(z)
    primes.add(v)
    stdout.write fmt"{insertSep($v, ','):>11}"
    if c mod 10 == 0:
      stdout.write "\n"
    if c == cutOff:
      showEach = false
      stdout.write fmt"Progress to the {insertSep($bigUn, ',')}th cuban prime: "
      stdout.flushFile
  if c mod little == 0:
    stdout.write "."
    stdout.flushFile
    if c == bigUn:
      break
stdout.write "\n"
echo fmt"The {c}th cuban prime is {insertSep($v, ',')}"
