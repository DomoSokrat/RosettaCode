{.experimental: "parallel".}
import strutils, threadpool

const SHA256Len = 32
proc SHA256(d: cstring, n: culong, md: cstring = nil): cstring {.cdecl, dynlib: "libssl.so", importc.}

const
  hashes = [
    "1115dd800feaacefdf481f1f9070374a2a81e27880f187396db67958b207cbad".parseHexStr,
    "3a7bd3e2360a3d29eea436fcfb7e44c735d117c42d1c1835420b6b9942dd4f1b".parseHexStr,
    "74e1bb62f8dabb8125a58852b63bdf6eaef667cb56ac7f7cdba6d7305c50a22f".parseHexStr
  ]
  charset = 'a' .. 'z'

# Based on the C++ version
proc nextPassword(pw: var string, start: Natural): bool =
  for i in countdown(pw.high, start):
    if pw[i] < 'z':
      inc pw[i]
      return true
    pw[i] = 'a'

proc checkPassword(c1: char) {.thread.} =
  var hash = newString(SHA256Len)
  var pw = c1 & "aaaa"
  while true:
    discard SHA256(pw, pw.len.culong, hash)
    for i in hashes.low .. hashes.high:
      if hash == hashes[i]:
        echo pw, " -> ", hash.toHex
    if not nextPassword(pw, 1):
      break

proc main() =
  parallel:
    for c1 in charset:
      spawn checkPassword(c1)

main()
