# Package

version       = "0.1.0"
author        = "genotrance"
description   = "libgit2 wrapper for Nim"
license       = "MIT"

skipDirs = @["tests"]

# Dependencies

requires "nimterop >= 0.2.0"

var
  name = "nimgit2"

when gorgeEx("nimble path nimterop").exitCode == 0:
  import nimterop/docs
  task docs, "Generate docs": buildDocs(@[name & ".nim"], "build/htmldocs")
else:
  task docs, "Do nothing": discard

task test, "Run tests":
  exec "nim c -r tests/t" & name & ".nim"
  exec "nim c -d:danger -r tests/t" & name & ".nim"
  docsTask()
