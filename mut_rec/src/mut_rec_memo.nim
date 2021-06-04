import std/monotimes
import memo

proc m(n: Natural): Natural

proc f(n: Natural): Natural {.memoized.} =
  if n == 0: 1
  else: n - m(f(n-1))

proc m(n: Natural): Natural {.memoized.} =
  if n == 0: 0
  else: n - f(m(n-1))

let start = getMonoTime()
for i in 1 .. 10:
  echo f(i)
  echo m(i)
echo f(100)
echo m(100)
let stop = getMonoTime()
echo stop-start
