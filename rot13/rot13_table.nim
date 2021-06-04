import strutils

func calc_replace_table: array[char, char] =
  for c in result.low .. result.high:
    result[c] =
      case toLowerAscii(c)
      of 'a'..'m': chr(ord(c) + 13)
      of 'n'..'z': chr(ord(c) - 13)
      else:        c

const replacement_table = calc_replace_table()

for line in stdin.lines:
  for c in line:
    stdout.write replacement_table[c]
  stdout.write "\n"
