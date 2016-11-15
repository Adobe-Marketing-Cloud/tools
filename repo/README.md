# repo - FTP-like tool for JCR content

Transfers filevault JCR content between the filesystem (unzipped content package) and a server such as AEM (running the package manager HTTP API). Great for development.

Similar to the `vlt` command line tool from [jackrabbit-filevault](http://jackrabbit.apache.org/filevault/overview.html), but faster, bash-script-only and with minimal dependencies.

How it works: For a given path inside a `jcr_root` filevault structure on the filesystem, it creates a package with a single filter for the entire subtree and pushes that to the server (put), fetches it from the server (get) or compares the differences (status and diff). Please note that it will always overwrite the entire file or directory specified. Does not support multiple filter paths or vlt's filter.xml.

[Licensed under Apache 2.0](../LICENSE).

## Installation

### Homebrew (Mac)

For [Homebrew](http://brew.sh) users it's available via the [adobe-marketing-cloud/brews tap](https://github.com/Adobe-Marketing-Cloud/homebrew-brews):
```
brew tap adobe-marketing-cloud/brews
brew install adobe-marketing-cloud/brews/repo
```

### Manual installation

`repo` is a single bash script depending on basic unix tools (zip, unzip, curl, rsync, mktemp). Download and put it onto your `PATH`:

[Download latest release](https://github.com/Adobe-Marketing-Cloud/tools/releases/latest).

Supported platforms:

- Mac OSX (+ curl, rsync)
- Linux (+ curl, rsync)
- Windows with Cygwin (+ zip, unzip, curl, rsync packages)

### Integration into IntelliJ

Want to hit a shortcut like `ctrl + cmd + P` and have your current open file or selected folder pushed to the server from within IntelliJ? Without having to save or anything else? Just set up these tools below.

Setup external tools under Settings > Tools > External Tools.
Add a group "repo" and add commands below, leaving the "Working directory" empty.
Keyboard shortcuts are managed under Settings > Keymap, search for "repo" after you created the external tool entries.
Below are examples, your milage may vary.

* put
  * Program: `repo` (if in $PATH, you can also specify absolute path here)
  * Parameters: `put -f $FilePath$`
  * Keyboard Shortcut: `ctrl + cmd + P`
* get
  * Program: `repo`
  * Parameters: `get -f $FilePath$`
  * Keyboard Shortcut: `ctrl + cmd + G` (note: already used by default keymap for grepping)
* status
  * Program: `repo`
  * Parameters: `st $FilePath$`
  * Keyboard Shortcut: `ctrl + cmd + S`
* diff
  * Program: `repo`
  * Parameters: `diff $FilePath$`
  * Keyboard Shortcut: `ctrl + cmd + D`

### Integration into Eclipse

Setup external tools under `Run > Exernal Tools > Exernal Tool Configurations...`.
Add a Programm which points to the `repo` shell script for each desired REPO operation. 
I would recommend to disable `Build before launch` in the Build tab.

Examples:  
* put
  * Location: `<install-path>/repo`
  * Working Directory: `${container_loc}`
  * Arguments: `put -f ${selected_resource_name}`
* get
  * Location: `<install-path>/repo`
  * Working Directory: `${container_loc}`
  * Arguments: `get -f ${selected_resource_name}`

## Usage

```
Usage: repo <command> [opts] [<path>]

FTP-like tool for JCR content, with support for diffing.

Transfers filevault JCR content between the filesystem (unzipped content package)
and a server such as AEM (running the package manager HTTP API).

For a given path inside a jcr_root filevault structure on the filesystem, it
creates a package with a single filter for the entire subtree and pushes that to
the server (put), fetches it from the server (get) or compares the differences
(status and diff). Please note that it will always overwrite the entire file or
directory specified. Does not support multiple filter paths or vlt's filter.xml.

Available commands:

  put                upload local file system content to server
  get                download server content to local file system
  status (st)        list status of modified/added/deleted files
  diff               show differences, same as 'localdiff'

  localdiff          show differences done locally compared to server
  serverdiff         show differences done on the server compared to local

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

## common options

```
Arguments:
  <path>             local directory or file to sync; defaults to current dir

Options:
  -h --help          show this help
  -s <server>        server, defaults to 'http://localhost:4502'
                     include context path if needed
  -u <user>:<pwd>    user and password, defaults to 'admin:admin'
```

## repo put

```
Usage: repo put [opts] [<path>]

Upload local file system content to server for the given path.

Options:
  -f                 force, don't ask for confirmation
  -q                 quiet, don't output anything
```

## repo get

```
Usage: repo get [opts] [<path>]

Download server content to local filesystem for the given path.

Options:
  -f                 force, don't ask for confirmation
  -q                 quiet, don't output anything
```

## repo status

```
Usage: repo status [opts] [<path>]

List status of files compared to the server at the given path.

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

Show differences done locally compared to server at the given path.

Same as 'localdiff', showing +++ if things were added locally.
If you made changes on the server, use 'serverdiff' instead.
```

## repo localdiff

```
Usage: repo localdiff [opts] [<path>]

Show differences done locally compared to server at the given path.

Showing +++ if things were added locally (or removed on the server).
If you made changes on the server, use 'serverdiff' instead.
```

## repo serverdiff

```
Usage: repo serverdiff [opts] [<path>]

Show differences done on the server compared to local at the given path.

Showing +++ if things were added on the server (or removed locally).
If you made changes locally, use 'localdiff' instead.
```
