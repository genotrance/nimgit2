import os, strutils

import nimterop/[build, cimport]

const
  baseDir = currentSourcePath.parentDir() / "build" / "libgit2"
  cmakeFlags = block:
    var
      cm = flagBuild("-D$#", @[
        "CMAKE_BUILD_TYPE=Release", "BUILD_CLAR=OFF", "USE_BUNDLED_ZLIB=ON",
        "USE_HTTP_PARSER=builtin", "REGEX_BACKEND=builtin"
      ])

    when isDefined(git2Static):
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

when isDefined(git2Static):
  cImport(git2Path, recurse = true)
  {.passL: git2LPath.}
  when defined(linux):
    const
      libs = linkLibs(@["ssl", "crypto", "ssh2"], staticLink = true)
    static:
      echo libs
    {.passL: libs.}
  elif defined(windows):
    # No libssh2 yet
    {.passL: "-lws2_32 -lwinhttp -lole32 -lcrypt32 -lRpcrt4".}
else:
  # Broken due to https://github.com/nimterop/nimterop/issues/134
  cImport(git2Path, recurse = true, dynlib = "git2LPath")
