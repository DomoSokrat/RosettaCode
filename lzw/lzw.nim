import math, sequtils, strutils, tables

#const charset = (Letters+Digits+Whitespace).toSeq & ".,?!=#'\"(){}[]+-*/$&\\:;_%<>".toSeq
const charset = AllChars.toSeq
const input_bit_width = charset.len.float.log2.ceil.int

static:
  echo charset.len
  echo input_bit_width

## build the dictionaries
var comp_dictionary = initTable[string, int](charset.len.rightSize)
for i, c in charset:
  comp_dictionary.add($c, i)
var decomp_dictionary = initTable[int, string](charset.len.rightSize)
for i, c in charset:
  decomp_dictionary.add(i, $c)

proc compress*(uncompressed: string, dictSize: var int): seq[int] =
  var dictionary = comp_dictionary
  var w = ""

  for c in uncompressed:
    let wc = w & c
    if wc in dictionary:
      w = wc
    else:
      # writes w to output
      result.add dictionary[w]
      # if dictionary is full, restart
      if dictionary.len == 1 shl 12:
        dictionary = comp_dictionary
      # wc is a new sequence; add it to the dictionary
      dictionary.add(wc, dictionary.len)
      w = $c

  # write remaining output if necessary
  if w != "":
    result.add dictionary[w]

  dictSize = dictionary.len

proc compress*(uncompressed: string): seq[int] =
  var dictSize: int
  compress(uncompressed, dictSize)


proc decompress*(compressed: seq[int]): string =
  var compressed = compressed
  var dictionary = decomp_dictionary

  var w = dictionary[compressed[0]]

  compressed.delete(0)

  result = w

  for k in compressed:
    var entry = ""
    if k in dictionary:
      entry = dictionary[k]
    elif k == dictionary.len:
      entry = w & w[0]
    else:
      raise newException(ValueError, "Bad compressed k: " & $k)

    result.add entry

    # if dictionary is full, restart
    if dictionary.len == 1 shl 12:
      dictionary = decomp_dictionary
    # new sequence; add it to the dictionary
    dictionary.add(dictionary.len, w & entry[0])

    w = entry

proc test*(s: string) =
  var dictSize: int;
  let compressed = compress(s, dictSize)
  let output_bit_width = dictSize.float.log2.ceil.int
  let cb = compressed.len * output_bit_width
  when isMainModule:
    echo compressed
  echo "compressed: ", compressed.len, " symbols, ", cb, " bits, ", output_bit_width, " bits/symbol"
  let decompressed = decompress(compressed)
  let db = decompressed.len * input_bit_width
  echo "decompressed: ", decompressed.len, " symbols, ", db, " bits, ", input_bit_width, " bits/symbol"
  echo "ratio: ", cb/db
  echo "round trip? ", s == decompressed

when isMainModule:
  import os
  if paramCount() == 0:
    test("TOBEORNOTTOBEORTOBEORNOT")
    echo()
    test("TO BE OR NOT TO BE OR TO BE OR NOT")
    echo()
  else:
    for s in commandLineParams():
      test(s)
      echo()
