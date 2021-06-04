import cpuinfo, strutils

const SHA256Len = 32
proc SHA256(d: cstring, n: culong, md: cstring = nil): cstring {.cdecl, dynlib: "libssl.so", importc.}

const
  hashes = [
    "1115dd800feaacefdf481f1f9070374a2a81e27880f187396db67958b207cbad".parseHexStr,
    "3a7bd3e2360a3d29eea436fcfb7e44c735d117c42d1c1835420b6b9942dd4f1b".parseHexStr,
    "74e1bb62f8dabb8125a58852b63bdf6eaef667cb56ac7f7cdba6d7305c50a22f".parseHexStr
  ]
  charset = 'a' .. 'z'

var
  pwChan: Channel[char]
  resChan: Channel[tuple[pw, hash: string]]

proc checkPassword() {.thread.} =
  var hash = newString(SHA256Len)
  while true:
    let c1 = pwChan.recv()
    if c1 == '\x00':
      break
    for c2 in charset:
      for c3 in charset:
        for c4 in charset:
          for c5 in charset:
            let pw = c1 & c2 & c3 & c4 & c5
            discard SHA256(pw, pw.len.culong, hash)
            for i in hashes.low .. hashes.high:
              if hash == hashes[i]:
                resChan.send((pw, hash))
  resChan.send(("", ""))

proc printResults(count: Natural) {.thread.} =
  var count = count
  while count > 0:
    let (pw, hash) = resChan.recv()
    if pw == "" and hash == "":
      dec count
    else:
      echo pw, " -> ", hash.toHex

type Worker = Thread[void]

proc main() =
  pwChan.open()
  resChan.open()
  var checker = newSeq[Worker](countProcessors()-1)
  echo "Thread count ", checker.len
  for i in 0 .. checker.high:
    createThread(checker[i], checkPassword)
  var printer: Thread[Natural]
  createThread(printer, printResults, checker.len)
  for c1 in charset:
    pwChan.send(c1)
  # Tell the workers we are done
  for i in 0 .. checker.high:
    pwChan.send('\x00')
  joinThreads checker
  joinThread printer
  pwChan.close()
  resChan.close()

main()
