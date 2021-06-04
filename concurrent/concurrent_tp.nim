import threadpool
const str = ["Enjoy", "Rosetta", "Code"]
 
proc f(i: int) {.thread.} =
  echo str[i], " ", getThreadId()
 
for i in 0..str.high:
  spawn f(i)
sync()
