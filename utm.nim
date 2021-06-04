import strutils, tables

template showTape() =
  stdout.write st,'\t'
  for i, v in tape:
    if i == pos: stdout.write '[', v, ']'
    else:        stdout.write ' ', v, ' '
  echo ""

proc runUTM(state, halt, blank: string, tape: seq[string] = @[],
            rules: seq[seq[string]], verbose = true) =
  var
    st = state
    pos = 0
    tape = tape
    rulesTable = initTable[tuple[s0, v0: string], tuple[v1, dr, s1: string]]()
    steps = 0u64

  if tape.len == 0: tape = @[blank]
  if pos < 0: pos += tape.len
  assert pos in 0..tape.high

  for r in rules:
    assert r.len == 5
    rulesTable[(r[0], r[1])] = (r[2], r[3], r[4])

  while true:
    if verbose:
      showTape()
    else:
      inc steps
      if steps mod 100_000 == 0:
        stdout.write steps, "\r"
        stdout.flushFile
      if steps mod 10_000_000 == 0:
        echo ""
        showTape()

    if st == halt: break
    if not rulesTable.hasKey((st, tape[pos])): break

    let (v1, dr, s1) = rulesTable[(st, tape[pos])]
    tape[pos] = v1
    if dr == "left":
      if pos > 0: dec pos
      else: tape.insert blank
    if dr == "right":
      inc pos
      if pos >= tape.len: tape.add blank
    st = s1
  if not verbose:
    echo steps
    showTape()
  

echo "incr machine\n"
runUTM(halt  = "qf",
       state = "q0",
       tape  = "1 1 1".splitWhitespace,
       blank = "B",
       rules = @["q0 1 1 right q0".splitWhitespace,
                 "q0 B 1 stay  qf".splitWhitespace])

echo "\nbusy beaver\n"
runUTM(halt  = "halt",
       state = "a",
       blank = "0",
       rules = @["a 0 1 right b".splitWhitespace,
                 "a 1 1 left  c".splitWhitespace,
                 "b 0 1 left  a".splitWhitespace,
                 "b 1 1 right b".splitWhitespace,
                 "c 0 1 left  b".splitWhitespace,
                 "c 1 1 stay  halt".splitWhitespace])

echo "\nsorting test\n"
runUTM(halt  = "STOP",
       state = "A",
       blank = "0",
       tape  = "2 2 2 1 2 2 1 2 1 2 1 2 1 2".splitWhitespace,
       rules = @["A 1 1 right A".splitWhitespace,
                 "A 2 3 right B".splitWhitespace,
                 "A 0 0 left  E".splitWhitespace,
                 "B 1 1 right B".splitWhitespace,
                 "B 2 2 right B".splitWhitespace,
                 "B 0 0 left  C".splitWhitespace,
                 "C 1 2 left  D".splitWhitespace,
                 "C 2 2 left  C".splitWhitespace,
                 "C 3 2 left  E".splitWhitespace,
                 "D 1 1 left  D".splitWhitespace,
                 "D 2 2 left  D".splitWhitespace,
                 "D 3 1 right A".splitWhitespace,
                 "E 1 1 left  E".splitWhitespace,
                 "E 0 0 right STOP".splitWhitespace])

echo "\nlong running busy beaver\n"
runUTM(halt  = "H",
       state = "A",
       blank = "0",
       verbose = false,
       rules = @["A 0 1 right B".splitWhitespace,
                 "A 1 1 left  C".splitWhitespace,
                 "B 0 1 right C".splitWhitespace,
                 "B 1 1 right B".splitWhitespace,
                 "C 0 1 right D".splitWhitespace,
                 "C 1 0 left  E".splitWhitespace,
                 "D 0 1 left  A".splitWhitespace,
                 "D 1 1 left  D".splitWhitespace,
                 "E 0 1 stay  H".splitWhitespace,
                 "E 1 0 left  A".splitWhitespace])
