proc qselect[T](a: var openarray[T]; k: int; inl = 0, inr = -1): T =
  let r = if inr >= 0: inr else: a.high
  let mid = (inl+r+1) div 2

  if a[inl] > a[mid]: swap a[inl], a[mid]
  if a[r] > a[mid]: swap a[r], a[mid]
  if a[inl] > a[r]: swap a[inl], a[r]

  let pivot = a[r]
  var st = inl
  for i in inl ..< r:
    if a[i] > pivot: continue
    swap a[i], a[st]
    inc st

  swap a[r], a[st]

  if k == st:  a[st]
  elif st > k: qselect(a, k, inl, st - 1)
  else:        qselect(a, k, st, r)

import sequtils, random
let xs = [
  @[9, 8, 7, 6, 5, 0, 1, 2, 3, 4],
  toSeq(countUp(0, 19999)),
  toSeq(countDown(19999, 0)),
]

randomize(42)
var randSeq = toSeq(countUp(0, 19999))
shuffle(randSeq)

import times
let t1 = cpuTime()
for x in xs:
  for i in 0 .. x.high:
    var y = x
    let res = qselect(y, i)
    assert i == res
let t2 = cpuTime()
for i in 0 .. randSeq.high:
  var y = randSeq
  let res = qselect(y, i)
  assert i == res
let t3 = cpuTime()
echo t2-t1, " + ", t3-t2, " = ", t3-t1
