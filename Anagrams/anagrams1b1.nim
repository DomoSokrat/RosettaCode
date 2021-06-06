import tables, strutils
import std/monotimes

func letter_sort(s: var string) =
  for i in 1 .. s.high:
    let v = s[i]
    var j = i - 1
    while j >= 0 and s[j] > v:
      s[j+1] = s[j]
      dec j
    s[j+1] = v

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
