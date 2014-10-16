# repo - Script for JCR content synchronization

Uploads or downloads JCR content from a local filesystem to a server.
Simple replacement for the `vlt` tool from [jackrabbit-filevault](http://jackrabbit.apache.org/filevault/overview.html), written in plain bash instead of Java and is very fast.

It will take the given path and push that entire subtree to the server (or vice-versa), while overwriting everything below. It assumes an unzipped content package as file system structure, with a `jcr_root` folder denoting the root of the JCR. It does not require or support multiple filter paths and vlt's `filter.xml`.

[Licensed under Apache 2.0](../LICENSE).

## Installation

`repo` is a single bash script depending on basic unix tools (zip, unzip, curl, rsync, mktemp). Download and put it onto your `PATH`.

Supported platforms:

- Mac OSX (+ curl, rsync)
- Linux (+ curl, rsync)
- Windows with Cygwin (+ zip, unzip, curl, rsync packages)



## Usage

```
Usage: repo <command> [opts] [<path>]

Uploads or downloads JCR content from a local filesystem to a server.

Takes a given path inside a jcr_root/ filevault structure as single filter
to either upload or download that file or subtree using a content package.
Note in case of a directory, it will be entirely overwritten.

Available commands:

  put                upload local file system content to server
  get                download server content to local file system
  status (st)        list status of modified/added/deleted files
  diff               show differences between local filesystem and server

Config files:

  .repo

  Can be placed in checkout or any parent directory. Allows to configure
  server and credentials. Note that command line options take precedence.

  server=http://server.com:8080
  credentials=user:pwd


  .repoignore

  Placed in the jcr_root directory, this file can list files to ignore
  using glob patterns. Also supported are .vltignore files.

Examples:

  Assume a running CQ server on http://localhost:4502

  (1) Start from scratch, working on /apps/project available on server

      mkdir -p jcr_root/apps/project  # jcr_root is important
      repo get jcr_root/apps/project  # fetch /apps/project

  (2) Upload changes to server

      cd jcr_root/apps/project
      vim .content.xml                # some modifications
      repo put                        # upload & overwrite entire dir
      touch file.jsp                  # add new file
      repo put file.jsp               # just push single file

  (3) Download changes from server

      repo get

  (4) Show status and diff

      repo st
      repo diff

  (5) Use custom server & credentials

      repo st -s localhost:8888 -u user:pwd

  (6) Avoid interactive confirmation (force)
      Be careful, easy to wipe out your repository!

      repo put -f

Use 'repo <command> -h' for help on a specific command.
```

## repo put

```
Usage: repo put [opts] [<path>]

Upload local file system content to server for the given path.

Arguments:
  <path>             local directory or file to sync; defaults to current dir

Options:
  -h --help          show this help
  -s <server>        server, defaults to 'http://localhost:4502'
                     include context path if needed
  -u <user>:<pwd>    user and password, defaults to 'admin:admin'
  -f                 force, don't ask for confirmation
  -q                 quiet, don't output anything
```

## repo get

```
Usage: repo get [opts] [<path>]

Download server content to local filesystem for the given path.

Arguments:
  <path>             local directory or file to sync; defaults to current dir

Options:
  -h --help          show this help
  -s <server>        server, defaults to 'http://localhost:4502'
                     include context path if needed
  -u <user>:<pwd>    user and password, defaults to 'admin:admin'
  -f                 force, don't ask for confirmation
  -q                 quiet, don't output anything
```

## repo status

```
Usage: repo status [opts] [<path>]

List status of files compared to the server at the given path.

Arguments:
  <path>             local directory or file to sync; defaults to current dir

Options:
  -h --help          show this help
  -s <server>        server, defaults to 'http://localhost:4502'
                     include context path if needed
  -u <user>:<pwd>    user and password, defaults to 'admin:admin'

Status legend:
  M                  modified
  A                  added locally / deleted remotely
  D                  removed locally / added remotely
  ~ fd               conflict: local file vs. remote directory
  ~ df               conflict: local directory vs. remote file
```

## repo diff

```
Usage: repo diff [opts] [<path>]

Show differences between local filesystem and server at the given path.

Arguments:
  <path>             local directory or file to sync; defaults to current dir

Options:
  -h --help          show this help
  -s <server>        server, defaults to 'http://localhost:4502'
                     include context path if needed
  -u <user>:<pwd>    user and password, defaults to 'admin:admin'
```
