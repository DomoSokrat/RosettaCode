proc hailstone(n: int): auto =
  result = @[n]
  var n = n
  while n > 1:
    if (n and 1) == 1:
      n = 3 * n + 1
    else:
      n = n div 2
    result.add n

proc haillen(n: int): int =
  var n = n
  result = 1
  while n > 1:
    if (n and 1) == 1:
      n = (3 * n + 1) div 2
      result += 2
    else:
      n = n div 2
      result += 1

let h = hailstone 27
assert h.len == 112 and h[0..3] == @[27,82,41,124] and h[^4..^1] == @[8,4,2,1]
var m, mi = 0
let limit = 2_000_000
for i in 1 ..< limit:
  let n = haillen i
  if n > m:
    m = n
    mi = i
echo "Maximum length ", m, " was found for hailstone(", mi, ") for numbers <", limit
