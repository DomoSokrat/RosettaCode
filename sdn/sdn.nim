import strutils
 
proc isSelfDescribing(n: Natural): bool =
  let s = $n
  for i, ch in s:
    if s.count($i) != ch.ord - '0'.ord:
      return false
  return true
 
for x in 0 .. 100_000_000:
  if x.isSelfDescribing: echo x
