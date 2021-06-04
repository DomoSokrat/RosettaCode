iterator log_nodups_hamming(): int {.inline.} =
  let lb3 = 1
  proc mul3(): int = lb3
  yield mul3()

for h in log_nodups_hamming():
  break
for h in log_nodups_hamming():
  break
