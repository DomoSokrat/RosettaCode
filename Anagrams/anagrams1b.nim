import tables, strutils
import std/monotimes

func letter_sort(s: var string) =
  for i in 1 .. s.high:
    var j = i - 1
    while j >= 0 and s[j] > s[j+1]:
      swap s[j], s[j+1]
      dec j

proc main() =
  var
    count = 0
    anagrams = initTable[string, seq[string]]()

  for word in "unixdict.txt".lines():
    var key = word
    key.letter_sort
    anagrams.mgetOrPut(key, @[]).add(word)
    count = max(count, anagrams[key].len)

  for _, v in anagrams:
    if v.len == count:
      v.join(" ").echo

when isMainModule:
  let start = getMonotime()
  main()
  let stop = getMonotime()
  echo stop-start
