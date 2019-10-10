Nimgit2 is a [Nim](https://nim-lang.org/) wrapper for the [libgit2](https://github.com/libgit2/libgit2) library.

Nimgit2 is distributed as a [Nimble](https://github.com/nim-lang/nimble) package and depends on [nimterop](https://github.com/nimterop/nimterop) to generate the wrappers. The libgit2 source code is downloaded using Git so having ```git``` in the path is ironically required.

__Installation__

Nimgit2 can be installed via [Nimble](https://github.com/nim-lang/nimble):

```
> nimble install nimgit2
```

This will download and install nimgit2 in the standard Nimble package location, typically ~/.nimble. Once installed, it can be imported into any Nim program.

__Usage__

Module documentation can be found [here](https://genotrance.github.io/nimgit2/theindex.html)

```nim
import nimgit2

doAssert git_libgit2_init() > 0, "Failed to init"
```

Compile with `-d:git2Std` if libgit2 is already installed by your package manager. Use `-d:git2Git` or `-d:git2DL` if building from source is preferred. The `-d:git2SetVer=xxx` can be used to set a specific tag or version. These defines can also be set in code using `setDefines()`. See the nimterop docs for more details.

The libgit2 [docs](https://libgit2.org/libgit2/#HEAD) is a good reference guide on how to use the API.

__Credits__

Nimgit2 wraps the libgit2 source code and all licensing terms of [libgit2](https://github.com/libgit2/libgit2/blob/master/COPYING) apply to the usage of this package.

__Feedback__

Nimgit2 is a work in progress and any feedback or suggestions are welcome. It is hosted on [GitHub](https://github.com/genotrance/nimgit2) with an MIT license so issues, forks and PRs are most appreciated.
