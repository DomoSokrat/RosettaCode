type
  Mode = enum
    Encrypt
    Decrypt

const
  lAlphabet = "HXUCZVAMDSLKPEFJRIGTWOBNYQ"
  rAlphabet = "PTLNBQDEOYSFAVZKGJRIHWXUMC"

when defined(old):
  import strformat
  proc chao(text: string, mode: Mode, verbose: bool = false): string =
    var left = lAlphabet
    var right = rAlphabet
    var eText = newSeq[char](text.len)
    var temp: array[26, char]

    for i in 0..<text.len:
      if verbose:
        echo &"{left}  {right}"
      var index: int
      if mode == Encrypt:
        index = right.find(text[i])
        eText[i] = left[index]
      else:
        index = left.find(text[i])
        eText[i] = right[index]
      if i == text.len - 1:
        break

      # permute left
      for j in index..25:
        temp[j - index] = left[j]
      for j in 0..<index:
        temp[26 - index + j] = left[j]
      var store = temp[1]
      for j in 2..13:
        temp[j - 1] = temp[j]
      temp[13] = store
      left = ""
      for i in temp:
        left &= $i

      # permute right
      for j in index..25:
        temp[j - index] = right[j]
      for j in 0..<index:
        temp[26 - index + j] = right[j]
      store = temp[0]
      for j in 1..25:
        temp[j - 1] = temp[j]
      temp[25] = store
      store = temp[2]
      for j in 3..13:
        temp[j - 1] = temp[j]
      temp[13] = store
      right = ""
      for i in temp:
        right &= $i

    for i in eText:
      result &= $i

  var plainText = "WELLDONEISBETTERTHANWELLSAID"
  echo &"The original plaintext is: {plainText}"
  echo "\nThe left and right alphabets after each permutation during encryption are:\n"
  var cipherText = chao(plainText, Encrypt, true)
  echo &"\nThe ciphertext is: {cipherText}"
  var plainText2 = chao(cipherText, Decrypt, false)
  echo &"\nThe recovered plaintext is: {plainText2}"
else:
  import std/[algorithm, strutils]
  proc chao(text: string; mode: Mode; verbose = false): string =
    var
      left = lAlphabet
      right = rAlphabet
      eText = newSeq[char](text.len)

    for i in 0 ..< text.len:
      if verbose:
        echo left, "  ", right
      var index: int
      if mode == Encrypt:
        index = right.find(text[i])
        eText[i] = left[index]
      else:
        index = left.find(text[i])
        eText[i] = right[index]
      if i == text.len - 1:
        break

      # permute left
      left.rotateLeft(index)
      left.rotateLeft(1..13, 1)

      # permute right
      right.rotateLeft(index + 1)
      right.rotateLeft(2..13, 1)

    result = eText.join()

  let plainText = "WELLDONEISBETTERTHANWELLSAID"
  echo "The original plaintext is: ", plainText
  echo "\nThe left and right alphabets after each permutation during encryption are:\n"
  let cipherText = chao(plainText, Encrypt, true)
  echo "\nThe ciphertext is: ", cipherText
  let plainText2 = chao(cipherText, Decrypt, false)
  echo "\nThe recovered plaintext is: ", plainText2
