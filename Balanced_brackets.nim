from std/random import randomize, shuffle
from std/strutils import alignLeft, delete, find, repeat
from std/pegs import peg, match

randomize()

proc gen(n: int): string =
  result = "[]".repeat(n)
  shuffle(result)

func is_balanced1(txt: string): bool =
  var b = 0
  for c in txt:
    case c
    of '[':
      inc b
    of ']':
      dec b
      if b < 0: return false
    else: discard
  b == 0

proc is_balanced2(txt: string): bool =
  let parser = peg"""e <- bal* $
                     bal <- '[' bal* ']'"""
  txt.match parser

func is_balanced3(txt: string): bool =
  var txt = txt
  while true:
    let pos = txt.find "[]"
    if pos == -1: break
    txt.delete(pos, pos+1)
  txt.len == 0

proc main =
  for n in 0..9:
    for _ in 1..(if n==0: 1 else: 2):
      let s = gen(n)
      let r = s.is_balanced1
      doAssert r == s.is_balanced2
      doAssert r == s.is_balanced3
      echo ("'" & s & "'").alignLeft(20), " is ", (if r: "balanced" else: "not balanced")
main()

#from std/algorithm import nextPermutation
#from std/os import paramStr
#from std/strutils import parseInt
#proc countBalanced =
#  let n = paramStr(1).parseInt
#  var
#    s = "[".repeat(n) & "]".repeat(n)
#    total: Natural
#    counts: array[bool, Natural]
#  while true:
#    inc total
#    let r = s.is_balanced1
#    inc counts[r]
#    if not nextPermutation s: break
#  echo total, " permutations of size ", 2*n
#  echo counts[true], " balanced"
#  echo counts[false], " unbalaced"
#countBalanced()
