import std/[strformat, strutils]

proc BN_new(): pointer {.cdecl, dynlib: "libssl.so", importc.}
proc BN_is_prime_ex(bn: pointer; nchecks: cint; ctx, cb: pointer = nil): cint {.cdecl, dynlib: "libssl.so", importc.}
proc BN_set_word(bn: pointer; w: culonglong): cint {.cdecl, dynlib: "libssl.so", importc.}
proc BN_CTX_new(): pointer {.cdecl, dynlib: "libssl.so", importc.}

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
var
  bn = BN_new()
  ctx = BN_CTX_new()

for i in 1..high(BiggestInt):
  inc u, 6
  inc v, u
  discard BN_set_word(bn, v.culonglong)
  let found = BN_is_prime_ex(bn, 32, ctx)
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
