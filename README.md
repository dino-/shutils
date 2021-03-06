# shutils


## Synopsis

A collection of utilities for scripting and working in a shell


## Description

Utilities to assist with scripting and working in a shell. Utilities include
lambda and splitpath.

### lambda

Wraps a shell command in a lambda function to allow easier manipulation of the
argument list. This is useful when you need to repeatedly modify an argument
buried in middle of a long command, or perform flip-like manipulations to
reorder the arguments to a command.

### splitpath

A tool for splitting paths that's more reliable and straightforward than the
usual combination of `basename` and bash built-ins like `##*.` and `%.*`. This
tool has smarter support for extensions and spaces.


## Getting source

Source code is available from github at the [shutils](https://github.com/dino-/shutils) project page.


## Contact

Dino Morelli <dino@ui3.info>
