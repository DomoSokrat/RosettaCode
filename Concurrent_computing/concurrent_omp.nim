# --stackTrace:off
# -d:release (implies stackTrace:off)
{.localpassC: "-fopenmp"}
{.passL: "-fopenmp"}

const str = ["Enjoy", "Rosetta", "Code"]

for i in 0||str.high:
  echo str[i]
