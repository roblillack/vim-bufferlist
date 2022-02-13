# VIM bufferlist

This is an implementation of
[EMACS bufferlist](https://github.com/roblillack/emacs-bufferlist) for
[Vim](https://www.vim.org) or [Neovim](https://neovim.io).

[![asciicast](https://asciinema.org/a/468786.svg)](https://asciinema.org/a/468786)

## About

Upon keypress this script display a nice list of buffers on the left, which can
be selected with mouse or keyboard. As soon as a buffer is selected (Return,
double click) the list disappears.

The selection can be cancelled with the same key that is configured to open the
list or by pressing `q`. Movement key and mouse (wheel) should work as one
expects.

Buffers that are visible (in any window) are marked with `*`, ones that are
modified are marked with `+`.

To delete a buffer from the list (i.e. close the file) press `d`.

## Installation

As a Vundle user, add

    Plugin 'roblillack/vim-bufferlist'

to your `~/.vimrc` or `~/.config/nvim/init.vim`.

Alternatively, put bufferlist.vim file into your `~/.vim/plugin` directory and
set it up like this in your `~/.vimrc`:

## Usage

Configure a hotkey to open the bufferlist:

    map <silent> <F3> :call BufferList()<CR>

Optionally, change some of the settings, like the default and maximum width or
the colors used for the sidebar:

    let g:BufferListWidth = 25
    let g:BufferListMaxWidth = 50
    hi BufferSelected term=reverse ctermfg=white ctermbg=red cterm=bold
    hi BufferNormal term=NONE ctermfg=black ctermbg=darkcyan cterm=NONE

## License

Copyright(c) 2005-2022, [Robert Lillack](https://roblillack.net/) \
Redistribution in any form with or without modification permitted.
