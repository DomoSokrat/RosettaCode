proc GetBottleNumber(n: int): string =
  if n == 0:
    result = "No more bottles"
  elif n == 1:
    result = "1 bottle"
  else:
    result = $n & " bottles"
  result.add " of beer"

for bn in countdown(99, 1):
  let cur = GetBottleNumber(bn)
  echo cur, " on the wall,\n", cur, "."
  echo "Take one down and pass it around,\n", GetBottleNumber(bn-1), " on the wall.\n"

echo "No more bottles of beer on the wall,\nno more bottles of beer."
echo "Go to the store and buy some more,\n99 bottles of beer on the wall."
