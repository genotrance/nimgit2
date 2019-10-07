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
  task docs, "Generate docs":
    buildDocs(@[name & ".nim"], "build/htmldocs",
              defines = @["git2Static"])
else:
  task docs, "Do nothing": discard

task test, "Run tests":
  exec "nim c -d:git2Git -d:git2Static -r tests/t" & name & ".nim"
  docsTask()
