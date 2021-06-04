import tables, strutils, algorithm

proc main() =
  var
    count = 0
    anagrams = initTable[string, seq[string]]()
    longest: seq[string]

  for word in "unixdict.txt".lines():
    var key = word
    key.sort
    anagrams.mgetOrPut(key, @[]).add(word)
    if count < anagrams[key].len:
      longest = @[key]
      count = anagrams[key].len
    elif count == anagrams[key].len:
      longest.add key

  for k in longest:
    anagrams[k].join(" ").echo

when isMainModule:
  main()
