import tables, strutils

func letter_sort(s: var string) =
  var i = 1
  while i < s.len:
    let v = s[i]
    var j = i - 1
    while j >= 0 and s[j] > v:
      s[j+1] = s[j]
      dec j
    s[j+1] = v
    inc i

proc main() =
  var
    count = 0
    anagrams = initTable[string, seq[string]]()
    longest: seq[string]

  for word in "unixdict.txt".lines():
    var key = word
    key.letter_sort
    anagrams.mgetOrPut(key, newSeq[string]()).add(word)
    if count < anagrams[key].len:
      longest = @[key]
      count = anagrams[key].len
    elif count == anagrams[key].len:
      longest.add key

  for k in longest:
    anagrams[k].join(" ").echo

when isMainModule:
  main()
