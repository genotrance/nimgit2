# Package

version       = "0.2.0"
author        = "genotrance"
description   = "libgit2 wrapper for Nim"
license       = "MIT"

skipDirs = @["tests"]

# Dependencies

requires "nimterop >= 0.5.6"

var
  suffix = "--path:.. -r tests/tnimgit2.nim"
  force = ""

when gorgeEx("nimble path nimterop").exitCode == 0:
  import nimterop/docs
  task docs, "Generate docs":
    buildDocs(@["nimgit2.nim"], "build/htmldocs",
              defines = @["git2Conan", "git2SetVer=0.28.3", "git2Static"])
else:
  task docs, "Do nothing": discard

task testDyn, "Dynamic":
  exec "nim c " & force & " -d:git2DL -d:git2SetVer=1.0.0 " & suffix

task testStatic, "Static":
  exec "nim c " & force & " -d:git2Git -d:git2Static " & suffix

task testJBB, "JBB":
  exec "nim c " & force & " -d:git2JBB -d:git2SetVer=0.28.5 " & suffix

task testConan, "Conan":
  exec "nim c " & force & " -d:git2Conan -d:git2SetVer=0.28.3 " & suffix
  exec "nim c " & force & " -d:git2Conan -d:git2SetVer=0.28.3 -d:git2Static " & suffix

task test, "Run tests":
  force = "-f"
  testDynTask()
  testStaticTask()
  testJBBTask()
  testConanTask()
  docsTask()
