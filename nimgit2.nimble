# Package

version       = "0.2.0"
author        = "genotrance"
description   = "libgit2 wrapper for Nim"
license       = "MIT"

skipDirs = @["tests"]

# Dependencies

requires "nimterop >= 0.5.6"

var
  name = "nimgit2"
  force = " "

when gorgeEx("nimble path nimterop").exitCode == 0:
  import nimterop/docs
  task docs, "Generate docs":
    buildDocs(@[name & ".nim"], "build/htmldocs",
              defines = @["git2Git", "git2Static"])
else:
  task docs, "Do nothing": discard

task testDyn, "Dynamic":
  exec "nim c" & force & "--path:.. -d:git2DL -d:git2SetVer=1.0.0 -r tests/t" & name & ".nim"

task testStatic, "Static":
  exec "nim c" & force & "--path:.. -d:git2Git -d:git2Static -r tests/t" & name & ".nim"

task test, "Run tests":
  force = " -f "
  testDynTask()
  testStaticTask()
  docsTask()
