## Files
.vim
    directory of file type configurations and plugins
.vimrc
    my vim configuration
.screenrc
    my screen configuration

## Instructions
### Creating source files
Any file which matches the shell glob `_*` will be linked into `$HOME` as a symlink with the first `_`  replaced with a `.`

For example:

    _zshrc

becomes

    ${HOME}/.zshrc

### Installing source files
It's as simple as running:

    ./install.sh

From this top-level directory.

## Requirements
* zsh
