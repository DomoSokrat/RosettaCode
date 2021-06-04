import math, bignum, strutils, os
 
func isPrime(a: int): bool =
  if a == 2: return true
  if a < 2 or a mod 2 == 0: return false
  for i in countup(3, a.float.sqrt.int, 2):
    if a mod i == 0:
      return false
  true
 
func isMersennePrime(p: int): bool =
  if p == 2: return true
  let p = p.culong
  let mp = (newInt(1) shl p) - 1
  let two = newInt(2)
  var s = newInt(4)
  for i in 3 .. p:
    let sqr = s * s
    s = (sqr and mp) + (sqr shr p)
    s -= two
    if s >= mp: s -= mp
  s == 0
 
let upb = paramStr(1).parseInt
echo "Mersenne primes:"
for p in 2 .. upb:
  if isPrime(p) and isMersennePrime(p):
    stdout.write " M", p
    stdout.flushFile
echo ""
