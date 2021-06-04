{.experimental: "parallel".}
import threadpool
import libsha / sha256

const
  hashes = [
    "1115dd800feaacefdf481f1f9070374a2a81e27880f187396db67958b207cbad",
    "3a7bd3e2360a3d29eea436fcfb7e44c735d117c42d1c1835420b6b9942dd4f1b",
    "74e1bb62f8dabb8125a58852b63bdf6eaef667cb56ac7f7cdba6d7305c50a22f"
  ]
  charset = 'a' .. 'z'

var
  resChan: Channel[tuple[pw, hash: string]]

proc checkPassword(c1: char) {.thread.} =
  for c2 in charset:
    for c3 in charset:
      for c4 in charset:
        for c5 in charset:
          let pw = c1 & c2 & c3 & c4 & c5
          let hash = sha256hexdigest(pw)
          for i in hashes.low .. hashes.high:
            if hash == hashes[i]:
              #echo pw, " -> ", hash
              resChan.send((pw, hash))
  resChan.send(("", ""))

proc printResults(count: Natural) {.thread.} =
  var count = count
  while count > 0:
    let (pw, hash) = resChan.recv()
    if pw == "" and hash == "":
      dec count
    else:
      echo pw, " -> ", hash

proc main() =
  resChan.open()
  parallel:
    for c1 in charset:
      spawn checkPassword(c1)
    spawn printResults(charset.len)
  resChan.close()

main()
