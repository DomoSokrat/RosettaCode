{.experimental: "parallel".}
import threadpool
const str = ["Enjoy", "Rosetta", "Code"]
 
proc f(i: int) {.thread.} =
  echo str[i], " ", getThreadId()
 
parallel:
  for i in 0..str.high:
    spawn f(i)
