VIM bufferlist
==============

This is an implementation of [EMACS bufferlist](http://github.com/roblillack/emacs-bufferlist) for [VIM](http://www.vim.org).

About
-----

Upon keypress this script display a nice list of buffers on the left, which can
be selected with mouse or keyboard. As soon as a buffer is selected (Return,
double click) the list disappears.

The selection can be cancelled with the same key that is configured to open the
list or by pressing `q`. Movement key and mouse (wheel) should work as one
expects.

Buffers that are visible (in any window) are marked with `*`, ones that are
modified are marked with `+`.

To delete a buffer from the list (i.e. close the file) press `d`. 

Usage
-----

Put bufferlist.vim file into your `~/.vim/plugin` directory and set it up
like this in your `~/.vimrc`:

### Needed

    map <silent> <F3> :call BufferList()<CR>

### Optional

    let g:BufferListWidth = 25
    let g:BufferListMaxWidth = 50
    hi BufferSelected term=reverse ctermfg=white ctermbg=red cterm=bold
    hi BufferNormal term=NONE ctermfg=black ctermbg=darkcyan cterm=NONE

License
-------

Copyright(c) 2005, Robert Lillack <rob@burningsoda.com>
Redistribution in any form with or without modification permitted.

