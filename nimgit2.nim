import os, strutils

import nimterop/[build, cimport]

static:
  cDebug()

const
  baseDir = currentSourcePath.parentDir() / "build" / "libgit2"
  cmakeFlags = block:
    var
      cm = "-DCMAKE_BUILD_TYPE=Release -DBUILD_CLAR=OFF"

    when defined(git2Static):
      cm &= " -DBUILD_SHARED_LIBS=OFF"

    cm

getHeader(
  "git2.h",
  giturl = "https://github.com/libgit2/libgit2",
  dlurl = "https://github.com/libgit2/libgit2/archive/v$1.zip",
  outdir = baseDir,
  cmakeFlags = cmakeFlags
)

cPlugin:
  import
    strutils, regex

  proc onSymbol*(sym: var Symbol) {.exportc, dynlib.} =
    sym.name = sym.name.strip(chars = {'_'}).replace(re"_[_]+", "_")

cDefine("GIT_DEPRECATE_HARD")

static:
  cSkipSymbol(@["git_odb_write_pack", "GIT_DIFF_LINE_CONTEXT"])

cOverride:
  type
    git_iterator* = object
    git_note_iterator* = object

when git2Static:
  cImport(git2Path, recurse = true)
  {.passL: git2LPath.}
else:
  cImport(git2Path, recurse = true, dynlib = "git2LPath")
