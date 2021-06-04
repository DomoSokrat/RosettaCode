import os
import lzw

for fn in commandLineParams():
  test(readFile(fn))
  echo()
