import os, strutils

import nimterop/[build, cimport]

const
  mode  =
    when isDefined(git2Static):
      "Static"
    else:
      "Dyn"
  baseDir = getProjectCacheDir("nimgit2" / "libgit2" & mode)
  cmakeFlags = block:
    var
      cm = flagBuild("-D$#", @[
        "CMAKE_BUILD_TYPE=Release", "BUILD_CLAR=OFF", "USE_BUNDLED_ZLIB=ON",
        "USE_HTTP_PARSER=builtin", "REGEX_BACKEND=builtin", "BUILD_CLAR=OFF"
      ])

    when isDefined(git2Static):
      cm &= " -DBUILD_SHARED_LIBS=OFF"

    when defined(osx):
      cm &= " -DOPENSSL_ROOT_DIR=/usr/local/opt/openssl"

    cm

getHeader(
  "git2.h",
  giturl = "https://github.com/libgit2/libgit2",
  dlurl = "https://github.com/libgit2/libgit2/archive/v$1.zip",
  outdir = baseDir,
  cmakeFlags = cmakeFlags
)

cPlugin:
  import strutils

  proc onSymbol*(sym: var Symbol) {.exportc, dynlib.} =
    sym.name = sym.name.strip(chars = {'_'}).replace("__", "_")

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
    {.passL: linkLibs(@["ssl", "crypto", "ssh2"], staticLink = true) & " -pthread".}
  elif defined(windows):
    # No libssh2 yet
    {.passL: "-lws2_32 -lwinhttp -lole32 -lcrypt32 -lRpcrt4".}
  elif defined(osx):
    {.passL: "-framework CoreFoundation -framework Security " &
             "-L/usr/local/opt/openssl/lib -lssl -lcrypto -liconv".}
else:
  cImport(git2Path, recurse = true, dynlib = "git2LPath")
