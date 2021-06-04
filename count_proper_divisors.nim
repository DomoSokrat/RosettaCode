from math import sqrt
from sequtils import toSeq
import strformat

const limit = 200_000

iterator primesUpto(limit: uint): uint =
  let sqrtLimit = uint(sqrt float64(limit))
  var composites = newSeq[bool](limit + 1)
  for n in 2u .. sqrtLimit:
    if not composites[n]: # if prime -> cull its composites
      for c in countup(n * n, limit, n):
        composites[c] = true
  for n in 2u .. limit:
    if not composites[n]:
      yield n

#iterator primesUpto1(limit: uint): uint =
#  var composites = newSeq[bool]((limit - 1) div 2)
#  let indexLimit = uint(sqrt float64(limit) - 3) div 2
#  let loopLimit = uint(composites.high)
#  for i in 0u .. indexLimit:
#    if not composites[i]: # if prime -> cull its composites
#      let p = i + i + 3
#      for c in countup((p * p - 3) div 2, loopLimit, p):
#        composites[c] = true
#  yield 2
#  for i in 0 .. composites.high:
#    if not composites[i]:
#      yield uint(i + i + 3)

let primes = toSeq(primesUpto(limit))

proc countProperDivisors(n: uint): uint =
  var nn = n
  var prod = 1u
  for p in primes:
    var count = 1u
    while nn mod p == 0:
      inc count
      nn = nn div p
    prod *= count
    if nn == 1: break
  prod - 1

var max = 0u
var maxI = 1u

for i in 1u..limit:
  var v = countProperDivisors(i)
  if v >= max:
    max = v
    maxI = i

echo fmt"{maxI} with {max} divisors"
