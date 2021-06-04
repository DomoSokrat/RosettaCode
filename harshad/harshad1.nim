import os, strutils

proc slice[T](iter: iterator(): T {.closure.}, sl: Slice[int]): seq[T] =
  var i = 0
  for n in iter():
    if i > sl.b:
      break
    if i >= sl.a:
      result.add(n)
    inc i

iterator harshad(): int64 {.closure.} =
  for n in 1 .. int64.high:
    var sum = 0
    for ch in $n:
      sum += parseInt("" & ch)
    if n mod sum == 0:
      yield n

echo harshad.slice 0 ..< 20

let limit = if paramCount() > 0: parseInt paramStr(1) else: 1000
for n in harshad():
  if n > limit:
    echo n
    break
