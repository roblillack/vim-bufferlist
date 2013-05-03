VIM bufferlist
==============

This is an implementation of [EMACS bufferlist](http://github.com/rockpiper/emacs-bufferlist) for [VIM](http://www.vim.org).

This fork contains additional modifications by Szymon Wrozynski. Basically, now it can:

* show unnamed buffers
* delete hidden buffers
* work with tab-related buffers
* open buffers in splits and tabs

Please, don't forget to star the repository if you like (and use) the plugin.
This will let me know how many users it has and then how to proceed with further
development :).

About
-----

Upon keypress this script display a nice list of buffers on the left, which
can be selected with mouse or keyboard. As soon as a buffer is selected
(`Return` (or `s`, `v`, `t`), double click) the list disappears.

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

If you want to toggle between all buffers view and those related with the current
tab only, press `a`.

*Related* means buffers seen in that tab at least once. This feature, called internally
*tab friends*, can be turned off by setting `g:BufferListShowTabFriends = 0`.
To see all buffers by default switch `g:BufferListShowTabFriends = 1`.
If you set `g:BufferListShowTabFriends = 2` (default) tab friends are turned on and
visible by default. Of course, the `a` key can toggle the view all the time.

You can also detach a tab friend buffer from the current tab. We would say
to make it a foreign one ;). To perform that press `f` (a good mnemonic could be *forget*)

You can also close all detached (foreign) buffers, if you press uppercase letter `F`.
This can be useful to clean up "orphaned" buffers, if you just have closed the tab
you were working with.

### Keys summary ###

<table>
<tr>
<th>Key</th>
<th>Action</th>
</tr>
<tr>
<td><code>Return</code></td>
<td>Opens the selected buffer</td>
</tr>
<tr>
<td><code>t</code></td>
<td>Opens the selected buffer in a new tab</td>
</tr>
<tr>
<td><code>s</code></td>
<td>Opens the selected buffer in a new horizontal split</td>
</tr>
<tr>
<td><code>v</code></td>
<td>Opens the selected buffer in a new vertical split</td>
</tr>
<tr>
<td><code>d</code></td>
<td>Deletes the selected buffer (closes it)</td>
</tr>
<tr>
<td><code>D</code></td>
<td>Deletes (closes) all hidden (not displayed in any tab) buffers</td>
</tr>
<tr>
<td><code>f</code></td>
<td>Forgets the current buffer (make it a <em>foreign</em> (unrelated) to the current tab)</td>
</tr>
<tr>
<td><code>F</code></td>
<td>Deletes (closes) all forgotten buffers (unrelated with any tab)</td>
</tr>
<tr>
<td><code>q</code> or <code>F2</code></td>
<td>Closes the list</td>
</tr>
</table>

Usage
-----

Put bufferlist.vim file into your `~/.vim/plugin` directory and set it up
like this in your `~/.vimrc`:

### Needed

    map <silent> <F2> :BufferList<CR>

### Optional

    let g:BufferListShowUnnamed = 1
    let g:BufferListShowTabFriends = 1
    let g:BufferListWidth = 25
    let g:BufferListMaxWidth = 50
    hi BufferSelected term=reverse ctermfg=white ctermbg=red cterm=bold
    hi BufferNormal term=NONE ctermfg=black ctermbg=darkcyan cterm=NONE

License
-------

Copyright(c) 2005, Robert Lillack <rob@burningsoda.com>
Redistribution in any form with or without modification permitted.

Modifications (c) 2013, Szymon Wrozynski <szymon@wrozynski.com>
