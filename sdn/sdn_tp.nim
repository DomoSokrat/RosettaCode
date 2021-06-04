import strutils
import threadpool
{.experimental.}

proc isSelfDescribing(n: Natural): bool =
  let s = $n
  for i, ch in s:
    if s.count($i) != ch.ord - '0'.ord:
      return false
  return true

proc p(lo, hi: Natural) {.thread.} =
  #echo getThreadId(), ":", lo
  for x in lo .. hi:
    if x.isSelfDescribing: echo x
  #echo getThreadId(), ":done"

const block_size = 5_000_000
for x in countup(0, 100_000_000-block_size, block_size):
  spawn p(x, x+block_size-1)
sync()
