VIM bufferlist
==============

This is an implementation of [EMACS bufferlist](http://github.com/rockpiper/emacs-bufferlist) for [VIM](http://www.vim.org).

This fork contains additional modifications by Szymon Wrozynski. Basically, now it can:

* show unnamed buffers
* delete hidden buffers
* show tab-related buffers only

Please, don't forget to star the repository if you like (and use) the plugin.
This will let me know how many users it has and then how to proceed with further
development :).

About
-----

Upon keypress this script display a nice list of buffers on the left, which
can be selected with mouse or keyboard. As soon as a buffer is selected
(Return, double click) the list disappears.

The selection can be cancelled with the same key that is configured to open
the list or by pressing `q`. Movement key and mouse (wheel) should work as
one expects.

Buffers that are visible (in any window) are marked with `*`, ones that are
modified are marked with `+`.

You can adjust the displaying of unnamed buffers. If you set
`g:BufferListShowUnnamed = 1` then unnamed buffers will be shown on the list
any time. However, if you set this value to `2` (default), unnamed buffers will
be displayed only if they are modified or just visible on the screen.

Of course you can hide unnamed buffers permanently by `g:BufferListShowUnnamed = 0`.

To delete a buffer from the list (i.e. close the file) press `d`.

To delete all hidden buffers (the ones not visible in any tab) press `D` (uppercase).

If you want to see buffers related with the current tab only, press `t`.

*Related* means buffers seen in that tab at least once. To switch back to all
buffers view, press `t` again. This feature, called internally *tab friends*,
can be turned off by setting `g:BufferListShowTabFriends = 0`.
If you set `g:BufferListShowTabFriends = 2` tab friends are turned on and
visible by default. Of course, the `t` key can toggle the view all the time.

You can also detach a tab friend buffer from the current tab. We would say
to make it a stranger ;). To perform that press `T` (uppercase).

Usage
-----

Put bufferlist.vim file into your `~/.vim/plugin` directory and set it up
like this in your `~/.vimrc`:

### Needed

    map <silent> <F2> :BufferList<CR>

### Optional

    let g:BufferListShowUnnamed = 1
    let g:BufferListShowTabFriends = 2
    let g:BufferListWidth = 25
    let g:BufferListMaxWidth = 50
    hi BufferSelected term=reverse ctermfg=white ctermbg=red cterm=bold
    hi BufferNormal term=NONE ctermfg=black ctermbg=darkcyan cterm=NONE

License
-------

Copyright(c) 2005, Robert Lillack <rob@burningsoda.com>
Redistribution in any form with or without modification permitted.

