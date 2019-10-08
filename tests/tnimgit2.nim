import os

import nimgit2

proc dumpError() =
  let err = git_error_last()
  if err == nil:
    return
  stdmsg().writeLine "\"" & $err.message & "\""
  quit(err.klass)

proc init*() =
  let count = git_libgit2_init()
  if count > 0:
    return
  assert count != 0, "unable to initialize libgit2; no error code!"
  dumpError()

proc shutdown*() =
  let count = git_libgit2_shutdown()
  if count == 0:
    return
  assert count > 0, $count & " too many git inits"
  dumpError()

when isMainModule:
  init()
  shutdown()
