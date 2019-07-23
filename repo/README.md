# repo - FTP-like tool for JCR content

Transfers filevault JCR content between the filesystem (unzipped content package) and a server such as AEM (running the package manager HTTP API). Great for development.

Similar to the `vlt` command line tool from [jackrabbit-filevault](http://jackrabbit.apache.org/filevault/overview.html), but faster, bash-script-only and with minimal dependencies.

How it works: For a given path inside a `jcr_root` filevault structure on the filesystem, it creates a package with a single filter for the entire subtree and pushes that to the server (put), fetches it from the server (get) or compares the differences (status and diff). Please note that it will always overwrite the entire file or directory specified. Does not support multiple filter paths or vlt's filter.xml.

[Licensed under Apache 2.0](../LICENSE).

## Table of Contents

* [Installation](#installation)
  * [Homebrew (Mac)](#homebrew-mac)
  * [Manual installation](#manual-installation)
  * [Integration into IntelliJ](#integration-into-intellij)
  * [Integration into Eclipse](#integration-into-eclipse)
  * [Integration into Visual Studio Code](#integration-into-visual-studio-code)
* [Usage](#usage)
  * [common options](#common-options)
  * [repo checkout (since 1.4)](#repo-checkout-since-14)
  * [repo put](#repo-put)
  * [repo get](#repo-get)
  * [repo status](#repo-status)
  * [repo diff](#repo-diff)
  * [repo localdiff](#repo-localdiff)
  * [repo serverdiff](#repo-serverdiff)

## Installation

Official release versions are [tracked here on github](https://github.com/Adobe-Marketing-Cloud/tools/releases).

### Homebrew (Mac)

For [Homebrew](http://brew.sh) users releases are available via the [adobe-marketing-cloud/brews tap](https://github.com/Adobe-Marketing-Cloud/homebrew-brews):
```
brew tap adobe-marketing-cloud/brews
brew install adobe-marketing-cloud/brews/repo
```

### Manual installation

`repo` is a single bash script depending on basic unix tools (zip, unzip, curl, rsync, mktemp).

Download and put it onto your `$PATH`:

* [Download latest release](https://github.com/Adobe-Marketing-Cloud/tools/releases/latest).
* [Download latest beta](repo) - just the script directly from this github repository.

Supported platforms:

- Mac OSX (+ curl, rsync)
- Linux (+ curl, rsync)
- Windows with Cygwin (+ zip, unzip, curl, rsync packages)

### Integration into IntelliJ

Want to hit a shortcut like `ctrl + cmd + P` and have your current open file or selected folder pushed to the server from within IntelliJ? Without having to save or anything else? Just set up these tools below.

Setup external tools under Settings > Tools > External Tools.
Add a group "repo" and add commands below, leaving the "Working directory" empty.
Keyboard shortcuts are managed under Settings > Keymap, search for "repo" after you created the external tool entries.
Below shortcuts are examples, your milage may vary.

#### Mac:

* put
  * Program: `repo` (if in `$PATH`, otherwise use the absolute path to repo here)
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

#### Windows:

Cygwin or Windows Subsystem for Linux (WSL) is required, and repo must be called explicitly using Cygwin's or WSL's `bash`. The examples below are for WSL. In order to use Cygwin, replace `mnt` with `cygdrive` as the second parameter for repoWrapper.ps1.

Make sure the folder containing `repo` is in Windows' `$Path` variable. Alternatively replace `repoWrapper.ps1` in the parameters below with the full absolute path, for example `C:\tools\repoWrapper.ps1`.

* put
  * Program: `powershell`
  * Parameters: `repoWrapper.ps1 put mnt $FilePath$`
  * Keyboard Shortcut: `Ctrl + Alt + Shift + Q`

* get
  * Program: `powershell`
  * Parameters: `repoWrapper.ps1 get mnt $FilePath$`
  * Keyboard Shortcut: `Ctrl + Alt + Shift + R`

* status
  * Program: `powershell`
  * Parameters: `repoWrapper.ps1 status mnt $FilePath$`
  * Keyboard Shortcut: `Ctrl + Alt + Shift + Y`

* diff
  * Program: `powershell`
  * Parameters: `repoWrapper.ps1 diff mnt $FilePath$`
  * Keyboard Shortcut: `Ctrl + Alt + Shift + E`

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

### Integration into Visual Studio Code

Configure custom tasks under `Terminal > Configure Tasks... > Create tasks.json file from template > Others`.
This will create a `tasks.json` beneath a `.vscode` directory in the current workspace.

Below are examples for tasks using `repo`, assuming `repo` has been added and available at the terminal path. 

*Note, variables available are scoped to the current opened file. See [Variables Reference](https://code.visualstudio.com/docs/editor/variables-reference) for more info.*

```
// .vscode/tasks.json
{
    // examples of using repo to push and pull files and folders from a server running at localhost:4502
    // the tasks with folders actions will be perfomed on the folder of the current file open in the editor
    // see https://code.visualstudio.com/docs/editor/variables-reference for more details
    
    "version": "2.0.0",
    "tasks": [
        {
            "label": "put file",
            "type": "shell",
            "command": "repo put -f ${file}",
            "problemMatcher": []
        },
        {
            "label": "put folder",
            "type": "shell",
            "command": "repo put -f ${fileDirname}",
            "problemMatcher": []
        },
        {
            "label": "get file",
            "type": "shell",
            "command": "repo get -f ${file}",
            "problemMatcher": []
        },
        {
            "label": "get folder",
            "type": "shell",
            "command": "repo get -f ${fileDirname}",
            "problemMatcher": []
        }
    ]
}
```
Keyboard shortcuts can be created under `Code > Preferences > Keyboard Shortcuts > edit keybindings.json`

Below are examples of keyboard shortcuts to trigger the custom tasks, your mileage may vary. 

```
// keybindings.json
// keyboard shortcuts for repo tasks
[
    {
        "key": "ctrl+cmd+p",
        "command": "workbench.action.tasks.runTask",
        "args": "put file"
    },
    {
        "key": "shift+cmd+p",
        "command": "workbench.action.tasks.runTask",
        "args": "put folder"
    },
    {
        "key": "ctrl+cmd+g",
        "command": "commandId",
        "when": "editorTextFocus"
    },{
        "key": "ctrl+cmd+g",
        "command": "workbench.action.tasks.runTask",
        "args": "get file"
    },
   {
        "key": "shift+cmd+g",
        "command": "workbench.action.tasks.runTask",
        "args": "get folder"
    }
]
```

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

  checkout           intial checkout of server content on file system
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

      repo checkout /apps/project

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

## repo checkout (since 1.4)

```
Usage: repo checkout [opts] [<jcr-path>]

Initially check out <jcr-path> from the server on the file system.

This will create a jcr_root folder in the current directory and check
out the <jcr-path> in there. If this is called within a jcr_root or
a jcr_root exists within the current directory, it will detect that
and check out the <jcr-path> in there.

Arguments:
  <jcr-path>         jcr path to checkout (should be a folder)
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
