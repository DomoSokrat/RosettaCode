# from https://rosettacode.org/wiki/Sorting_Algorithms/Circle_Sort#Nim

proc innerCircleSort[T](a: var openArray[T], lo, hi, swaps: int): int =
  var localSwaps: int = swaps
  var localHi: int = hi
  var localLo: int = lo
  if localLo == localHi:
    return swaps
 
  let mid = (localHi + localLo) div 2
 
  while localLo < localHi:
    if a[localLo] > a[localHi]:
      swap a[localLo], a[localHi]
      inc localSwaps
    inc localLo
    dec localHi
  if localLo == localHi and a[localLo] > a[localLo + 1]:
    swap a[localLo], a[localLo + 1]
    inc localSwaps
 
  localSwaps = a.innerCircleSort(lo, mid, localSwaps)
  localSwaps = a.innerCircleSort(mid + 1, hi, localSwaps)
  localSwaps
 
proc circleSort[T](a: var openArray[T]) =
  while a.innerCircleSort(0, a.high, 0) != 0:
    discard
 
var arr = @[@[6, 7, 8, 9, 2, 5, 3, 4, 1],
            @[2, 14, 4, 6, 8, 1, 3, 5, 7, 11, 0, 13, 12, -1]]
 
for i in 0..arr.high:
  echo "Original: ", $arr[i]
  arr[i].circleSort()
  echo "Sorted: ", $arr[i], if i != arr.high: "\n" else: ""
