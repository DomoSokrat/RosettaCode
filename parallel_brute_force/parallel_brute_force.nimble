# Package

version       = "0.1.0"
author        = "Marc Christiansen"
description   = "Inspired by https://rosettacode.org/wiki/Parallel_Brute_Force"
license       = "MIT"
srcDir        = "src"
bin           = @["parallel_brute_force", "parallel_brute_force_tp",
"parallel_brute_force_tp_alt"]



# Dependencies

requires "nim >= 1.2.0"
requires "nimSHA2 >= 0.1.1"
requires "libsha >= 1.0"
