import strformat, bitops

proc hailstone(n: int): auto =
  result = @[n]
  var n = n
  while n > 1:
    if (n and 1) == 1:
      n = 3 * n + 1
    else:
      n = n div 2
    result.add n

proc hailmax(n: int): bool =
  var n = n
  while n > 1:
    if (n and 1) == 1:
      n = 3 * n + 1
      if n >= 1 shl 32: return true
    else:
      n = n div 2

let limit = 2_000_000
for i in 1 ..< limit:
  if hailmax i:
    let hs = hailstone i
    echo i, ": ", hs.len
    for j in 0 .. hs.high:
      echo fmt"{hs[j]:12} {hs[j]:35b} {hs[j].fastLog2+1}"
    break
