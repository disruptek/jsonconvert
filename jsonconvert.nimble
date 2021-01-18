version = "1.0.2"
author = "disruptek"
description = "jsonconvert"
license = "MIT"

when not defined(release):
  requires "https://github.com/disruptek/balls >= 2.0.0 & < 3.0.0"

task test, "run the unit tests":
  when defined(windows):
    exec "balls.cmd"
  else:
    exec "balls"
