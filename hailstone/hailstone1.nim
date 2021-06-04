proc hailstone(n: int): auto =
  result = @[n]
  var n = n
  while n > 1:
    if (n and 1) == 1:
      n = 3 * n + 1
    else:
      n = n div 2
    result.add n

let h = hailstone 27
assert h.len == 112 and h[0..3] == @[27,82,41,124] and h[^4..^1] == @[8,4,2,1]
var m, mi = 0
let limit = 2_000_000
for i in 1 ..< limit:
  let n = hailstone(i).len
  if n > m:
    m = n
    mi = i
echo "Maximum length ", m, " was found for hailstone(", mi, ") for numbers <", limit
