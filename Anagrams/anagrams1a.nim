import tables, strutils, algorithm

proc main() =
  var
    count = 0
    anagrams = initTable[string, seq[string]]()

  for word in "unixdict.txt".lines():
    var key = word
    key.sort
    anagrams.mgetOrPut(key, @[]).add(word)
    count = max(count, anagrams[key].len)

  for _, v in anagrams:
    if v.len == count:
      v.join(" ").echo

when isMainModule:
  main()
