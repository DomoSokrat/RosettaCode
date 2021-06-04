const str = ["Enjoy", "Rosetta", "Code"]
 
var thr: array[str.len, Thread[int]]
 
proc f(i:int) {.thread.} =
  echo str[i]
 
for i in 0..thr.high:
  createThread(thr[i], f, i)
joinThreads(thr)
