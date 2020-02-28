version = "1.0.2"
author = "disruptek"
description = "jsonconvert"
license = "MIT"
requires "nim >= 0.20.0"

proc execCmd(cmd: string) =
  echo "execCmd:" & cmd
  exec cmd

proc execTest(test: string) =
  execCmd "nim c           -f -r " & test
  execCmd "nim c   -d:release -r " & test
  execCmd "nim c   -d:danger  -r " & test
  execCmd "nim cpp            -r " & test
  execCmd "nim cpp -d:danger  -r " & test
  when NimMajor >= 1 and NimMinor >= 1:
    execCmd "nim c --useVersion:1.0 -d:danger -r " & test
    execCmd "nim c   --gc:arc --exceptions:goto -r " & test
    execCmd "nim cpp --gc:arc --exceptions:goto -r " & test

task test, "run tests for travis":
  execTest("jsonconvert.nim")
