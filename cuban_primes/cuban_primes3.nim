import std/[strformat, strutils]
import gmp

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
var bn: mpz_t
mpz_init(bn)

for i in 1..high(BiggestInt):
  inc u, 6
  inc v, u
  mpz_set_si(bn, v)
  let found = mpz_probab_prime_p(bn, 32)
  if found == 0:
    continue
  inc c
  if showEach:
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
