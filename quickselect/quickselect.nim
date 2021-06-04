proc qselect_rec[T](a: var openarray[T]; k: int; inl = 0, inr = -1): T =
  let r = if inr >= 0: inr else: a.high
  let pivot = a[r]
  var st = inl
  for i in inl ..< r:
    if a[i] > pivot: continue
    swap a[i], a[st]
    inc st

  swap a[r], a[st]

  if k == st:  a[st]
  elif st > k: qselect_rec(a, k, inl, st - 1)
  else:        qselect_rec(a, k, st, r)

proc qselect_it[T](a: var openarray[T]; k: int; inl = 0, inr = -1): T =
  var l = inl
  var r = if inr >= 0: inr else: a.high
  while true:
    var st = l
    let pivot = a[r]
    for i in l ..< r:
      if a[i] > pivot: continue
      swap a[i], a[st]
      inc st

    swap a[r], a[st]

    if k == st: break
    elif st > k: r = st - 1
    else:        l = st
  a[k]

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

proc qselect_a[T](a: var openarray[T]; k: int; inl = 0, inr = -1): T =
  let r = if inr >= 0: inr else: a.high
  let mid = (inl+r+1) div 2

  if a[inl] < a[mid]:
    if   a[mid] < a[r]: swap a[mid], a[r]
    elif a[r] < a[inl]: swap a[inl], a[r]
  elif   a[r] < a[mid]: swap a[mid], a[r]
  elif   a[inl] < a[r]: swap a[inl], a[r]

  let pivot = a[r]
  var st = inl
  for i in inl ..< r:
    if a[i] > pivot: continue
    swap a[i], a[st]
    inc st

  swap a[r], a[st]

  if k == st:  a[st]
  elif st > k: qselect_a(a, k, inl, st - 1)
  else:        qselect_a(a, k, st, r)

import sequtils, random
let xs = [
  @[9, 8, 7, 6, 5, 0, 1, 2, 3, 4],
  toSeq(countUp(0, 19999)),
  toSeq(countDown(19999, 0)),
]

#randomize(42)
#var randSeq = toSeq(countUp(0, 19999))
#shuffle(randSeq)

import times
template check_impl(function: untyped): untyped =
  #for i in 0..9:
  #  var y = xs[0]
  #  echo i, ": ", function(y, i)
  for x in xs:
    for i in 0..x.high:
      var y = x
      let res = function(y, i)
      assert i == res
  #for i in 0..randSeq.high:
  #  var y = randSeq
  #  let res = function(y, i)
  #  assert i == res

#block:
#  let start = cpuTime()
#  check_impl(qselect_rec)
#  echo cpuTime() - start
#echo "----"
#block:
#  let start = cpuTime()
#  check_impl(qselect_it)
#  echo cpuTime() - start
#echo "----"
block:
  let start = cpuTime()
  check_impl(qselect)
  echo cpuTime() - start
echo "----"
block:
  let start = cpuTime()
  check_impl(qselect_a)
  echo cpuTime() - start
echo "----"
block:
  let start = cpuTime()
  check_impl(qselect)
  echo cpuTime() - start
echo "----"
block:
  let start = cpuTime()
  check_impl(qselect_a)
  echo cpuTime() - start
