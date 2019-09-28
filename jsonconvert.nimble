version = "1.0.0"
author = "disruptek"
description = "jsonconvert"
license = "MIT"
requires "nim >= 0.20.0"

task test, "Runs the test suite":
  exec "nim c -r jsonconvert.nim"
