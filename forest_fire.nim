import os, sequtils, strutils, random, terminal
import threadpool
randomize()

type
  State = enum Empty = "  ", Tree = "\e[32m/\\\e[m", Fire = "\e[07;31m/\\\e[m"
  Forest = seq[seq[State]]

const
  treeProb = 0.01
  burnProb = 0.001

proc chance(prob: float): bool = rand(1.0) < prob

# Set the size
let (w, h) = block:
  var w, h: int
  if paramCount() >= 2:
    w = parseInt paramStr 1
    h = parseInt paramStr 2
  if w <= 0: w = 30
  if h <= 0: h = 30
  (w, h)

# Iterate over fields in the universe
iterator fields(a = (0, 0), b = (h-1, w-1)): tuple[y, x: int] =
  for y in max(a[0], 0) .. min(b[0], h-1):
    for x in max(a[1], 0) .. min(b[1], w-1):
      yield (y, x)

func newForest(h, w: int): Forest = newSeqWith(h, newSeq[State] w)

func `[]`(s: Forest; y, x: int): State = s[y][x]
func `[]=`(s: var Forest; y, x: int; v: State) = s[y][x] = v

# Initialize
var univ, univNew = newForest(h, w)
var c = spawn getch()

while true:
  # Show
  stdout.write "\e[H"
  for y, x in fields():
    stdout.write univ[y, x]
    if x == w-1: stdout.write "\e[E"
  stdout.flushFile

  if c.isReady:
    if ^c == 'q':
      break
    else:
      c = spawn getCh()

  # Evolve
  for y, x in fields():
    case univ[y, x]
    of Fire:
      univNew[y, x] = Empty
    of Empty:
      if chance treeProb: univNew[y, x] = Tree
    of Tree:
      if chance burnProb:
        univNew[y, x] = Fire
        continue
      for y1, x1 in fields((y-1, x-1), (y+1, x+1)):
        if univ[y1, x1] == Fire:
          univNew[y, x] = Fire
          break
  univ = univNew
  sleep 200
