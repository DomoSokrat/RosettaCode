import os, strutils

func sumTo(n: Natural): Natural =
  n * (n+1) div 2
  #[
  if n mod 2 == 0:
    n div 2 * (n+1)
  else:
    (n+1) div 2 * n
  ]#

func coord2num(row, col, N: Natural): Natural =
  var start, offset: Natural
  let diag = col + row
  if diag < N:
    start = sumTo(diag)
    offset = if diag mod 2 == 0: col else: row
  else:
    # N * (2*diag+1-N) - sumTo(diag), but with smaller itermediates
    start = N*N - sumTo(2*N-1-diag)
    offset = N-1 - (if diag mod 2 == 0: row else: col)
  start + offset

let N = paramStr(1).parseUInt
let width = (N*N).`$`.len + 1
for row in 0 ..< N:
  for col in 0 ..< N:
    stdout.write(coord2num(row, col, N).`$`.align(width))
    #stdout.write(($coord2num(row, col, N)).align(width))
    #discard coord2num(row, col, N)
  stdout.write("\n")
