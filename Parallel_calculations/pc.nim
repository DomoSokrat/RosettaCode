import std/math
#import std/monotimes
import std/sequtils
#import std/strformat
import std/threadpool

#let gstart = getMonotime()

proc decompose(num: Natural): seq[Natural] {.thread.} =
  #let start = getMonotime()
  var n = num
  while n mod 2 == 0:
    result.add 2
    n = n div 2
  for i in countup(3, int(sqrt(float(n))), 2):
    while n mod i == 0:
      result.add i
      n = n div i
    if n < i:
      break
  if n > 1:
    result.add n
  #let stop = getMonotime()
  #echo fmt"num: {num:20} --> min. factor: {result[0]:8}  {stop-start} ({start-gstart:7} -> {stop-gstart:7})"


let numbers = [
  2'i64^59-1, 112_272_537_195_293,
  1_099_726_829_285_419, 1_275_792_312_878_611,
  115_284_584_522_153, 115_280_098_190_773,
  115_797_840_077_099, 112_582_718_962_171,
  12757923, 12878611, 12878893, 15808973, 15780709, 197622519,
]

var results = newSeq[FlowVar[seq[Natural]]](numbers.len)
for i in 0 .. results.high:
  results[i] = spawn decompose(numbers[i])

let
  factors = results.mapIt(^it)
  max_prime = factors.mapIt(it[0]).max

for i, r in factors.pairs:
  if max_prime == r[0]:
    echo numbers[i], ": ", r

#proc `==`(a: seq[Natural]; b: Natural): bool = a[0] == b
#let idx = factors.find(max_prime)
#echo numbers[idx], ": ", factors[idx]
