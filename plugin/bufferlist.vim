"=== VIM BUFFER LIST SCRIPT 1.4 ================================================
"= Copyright(c) 2005, Robert Lillack <rob@lillack.de>                          =
"= Redistribution in any form with or without modification permitted.          =
"=                                                                             =
"= Modifications and further improvements                                      =
"= (c) 2013 Szymon Wrozynski <szymon@wrozynski.com>, https://github.com/szw    =
"=                                                                             =
"= INFORMATION =================================================================
"= Upon keypress this script display a nice list of buffers on the left, which =
"= can be selected with mouse or keyboard. As soon as a buffer is selected     =
"= (Return, double click) the list disappears.                                 =
"= The selection can be cancelled with the same key that is configured to open =
"= the list or by pressing 'q'. Movement key and mouse (wheel) should work as  =
"= one expects.                                                                =
"= Buffers that are visible (in any window) are marked with '*', ones that are =
"= Modified are marked with '+'                                                =
"= To delete a buffer from the list (i.e. close the file) press 'd'.           =
"=                                                                             =
"= USAGE =======================================================================
"= Put this file into you ~/.vim/plugin directory and set up up like this in   =
"= your ~/.vimrc:                                                              =
"=                                                                             =
"= NEEDED:                                                                     =
"=     map <silent> <F2> :BufferList<CR>                                       =
"= OPTIONAL:                                                                   =
"=     let g:BufferListShowUnnamed = 1                                         =
"=     let g:BufferListShowTabFriends = 1                                      =
"=     let g:BufferListWidth = 25                                              =
"=     let g:BufferListMaxWidth = 50                                           =
"=     hi BufferSelected term=reverse ctermfg=white ctermbg=red cterm=bold     =
"=     hi BufferNormal term=NONE ctermfg=black ctermbg=darkcyan cterm=NONE     =
"===============================================================================

if exists('g:BufferListLoaded')
  finish
endif
let g:BufferListLoaded = 1

if !exists('g:BufferListWidth')
  let g:BufferListWidth = 20
endif

if !exists('g:BufferListMaxWidth')
  let g:BufferListMaxWidth = 40
endif

if !exists('g:BufferListShowUnnamed')
  let g:BufferListShowUnnamed = 2
endif

if !exists('g:BufferListShowTabFriends')
  let g:BufferListShowTabFriends = 2
endif

if g:BufferListShowTabFriends
  au BufEnter * call <SID>BufferListAddTabFriend()
endif

command! -nargs=0 -range BufferList :call <SID>BufferList(0)

" toggled the buffer list on/off
function! <SID>BufferList(internal)
  if !a:internal
    let s:tabfriendstoggle = (g:BufferListShowTabFriends == 2)
  endif

  " if we get called and the list is open --> close it
  if bufexists(bufnr("__BUFFERLIST__"))
    let l:buflistnr = bufnr("__BUFFERLIST__")
    let l:buflistwindow = bufwinnr(l:buflistnr)
    exec ':' . l:buflistnr . 'bwipeout'
    " if the list wasn't open, just the buffer existed, proceed with opening
    if l:buflistwindow != -1
      return
    endif
  endif

  let l:bufcount = bufnr('$')
  let l:displayedbufs = 0
  let l:activebuf = bufnr('')
  let l:activebufline = 0
  let l:buflist = ''
  let l:bufnumbers = ''
  let l:width = g:BufferListWidth

  " iterate through the buffers
  let l:i = 0 | while l:i <= l:bufcount | let l:i += 1
    if s:tabfriendstoggle && !exists('t:BufferListTabFriends[' . l:i . ']')
      continue
    endif

    let l:bufname = bufname(l:i)

    if g:BufferListShowUnnamed && !strlen(l:bufname)
      if !((g:BufferListShowUnnamed == 2) && !getbufvar(l:i, '&modified')) || (bufwinnr(l:i) != -1)
        let l:bufname = '[' . l:i . '*No Name]'
      endif
    endif

    if strlen(l:bufname) && getbufvar(l:i, '&modifiable') && getbufvar(l:i, '&buflisted')
      " adapt width and/or buffer name
      if l:width < (strlen(l:bufname) + 5)
        if strlen(l:bufname) + 5 < g:BufferListMaxWidth
          let l:width = strlen(l:bufname) + 5
        else
          let l:width = g:BufferListMaxWidth
          let l:bufname = '…' . strpart(l:bufname, strlen(l:bufname) - g:BufferListMaxWidth + 6)
        endif
      endif

      if bufwinnr(l:i) != -1
        let l:bufname .= '*'
      endif
      if getbufvar(l:i, '&modified')
        let l:bufname .= '+'
      endif
      " count displayed buffers
      let l:displayedbufs += 1
      " remember buffer numbers
      let l:bufnumbers .= l:i . ':'
      " remember the buffer that was active BEFORE showing the list
      if l:activebuf == l:i
        let l:activebufline = l:displayedbufs
      endif
      " fill the name with spaces --> gives a nice selection bar
      " use MAX width here, because the width may change inside of this 'for' loop
      while strlen(l:bufname) < g:BufferListMaxWidth
        let l:bufname .= ' '
      endwhile
      " add the name to the list
      let l:buflist .=  '  ' . l:bufname . "\n"
    endif
  endwhile

  " generate a variable to fill the buffer afterwards
  " (we need this for "full window" color :)
  let l:fill = "\n"
  let l:i = 0 | while l:i < l:width | let l:i += 1
    let l:fill = ' ' . l:fill
  endwhile

  " now, create the buffer & set it up
  exec 'silent! ' . l:width . 'vne __BUFFERLIST__'
  setlocal noshowcmd
  setlocal noswapfile
  setlocal buftype=nofile
  setlocal bufhidden=delete
  setlocal nobuflisted
  setlocal nomodifiable
  setlocal nowrap
  setlocal nonumber

  " set up syntax highlighting
  if has("syntax")
    syn clear
    syn match BufferNormal /  .*/
    syn match BufferSelected /> .*/hs=s+1
    hi def BufferNormal ctermfg=black ctermbg=white
    hi def BufferSelected ctermfg=white ctermbg=black
  endif

  setlocal modifiable
  if l:displayedbufs > 0
    " input the buffer list, delete the trailing newline, & fill with blank lines
    put! =l:buflist
    " is there any way to NOT delete into a register? bummer...
    "normal! Gdd$
    normal! GkJ
    while winheight(0) > line(".")
      put =l:fill
    endwhile
  else
    let l:i = 0 | while l:i < winheight(0) | let l:i += 1
      put! =l:fill
    endwhile
    normal! 0
  endif
  setlocal nomodifiable

  " set up the keymap
  noremap <silent> <buffer> <CR> :call <SID>LoadBuffer()<CR>
  map <silent> <buffer> q :bwipeout<CR>
  map <silent> <buffer> j :call <SID>BufferListMove("down")<CR>
  map <silent> <buffer> k :call <SID>BufferListMove("up")<CR>
  map <silent> <buffer> d :call <SID>BufferListDeleteBuffer()<CR>
  map <silent> <buffer> D :call <SID>BufferListDeleteHiddenBuffers()<CR>
  map <silent> <buffer> <MouseDown> :call <SID>BufferListMove("up")<CR>
  map <silent> <buffer> <MouseUp> :call <SID>BufferListMove("down")<CR>
  map <silent> <buffer> <LeftDrag> <Nop>
  map <silent> <buffer> <LeftRelease> :call <SID>BufferListMove("mouse")<CR>
  map <silent> <buffer> <2-LeftMouse> :call <SID>BufferListMove("mouse")<CR>
    \:call <SID>LoadBuffer()<CR>
  map <silent> <buffer> <Down> j
  map <silent> <buffer> <Up> k
  map <buffer> h <Nop>
  map <buffer> l <Nop>
  map <buffer> <Left> <Nop>
  map <buffer> <Right> <Nop>
  map <buffer> i <Nop>
  map <buffer> a <Nop>
  map <buffer> I <Nop>
  map <buffer> A <Nop>
  map <buffer> o <Nop>
  map <buffer> O <Nop>
  map <silent> <buffer> <Home> :call <SID>BufferListMove(1)<CR>
  map <silent> <buffer> <End> :call <SID>BufferListMove(line("$"))<CR>

  if g:BufferListShowTabFriends
    map <silent> <buffer> a :call <SID>BufferListToggleTabFriends()<CR>
    map <silent> <buffer> t :call <SID>BufferListDetachTabFriend()<CR>
    map <silent> <buffer> T :call <SID>BufferListDeleteForeignBuffers()<CR>
  endif

  " make the buffer count & the buffer numbers available
  " for our other functions
  let b:bufnumbers = l:bufnumbers
  let b:bufcount = l:displayedbufs

  " go to the correct line
  call <SID>BufferListMove(l:activebufline)
endfunction

" move the selection bar of the list:
" where can be "up"/"down"/"mouse" or
" a line number
function! <SID>BufferListMove(where)
  if b:bufcount < 1
    return
  endif
  let l:newpos = 0
  if !exists('b:lastline')
    let b:lastline = 0
  endif
  setlocal modifiable

  " the mouse was pressed: remember which line
  " and go back to the original location for now
  if a:where == "mouse"
    let l:newpos = line(".")
    call <SID>BufferListGoto(b:lastline)
  endif

  " exchange the first char (>) with a space
  call setline(line("."), " ".strpart(getline(line(".")), 1))

  " go where the user want's us to go
  if a:where == "up"
    call <SID>BufferListGoto(line(".")-1)
  elseif a:where == "down"
    call <SID>BufferListGoto(line(".")+1)
  elseif a:where == "mouse"
    call <SID>BufferListGoto(l:newpos)
  else
    call <SID>BufferListGoto(a:where)
  endif

  " and mark this line with a >
  call setline(line("."), ">".strpart(getline(line(".")), 1))

  " remember this line, in case the mouse is clicked
  " (which automatically moves the cursor there)
  let b:lastline = line(".")

  setlocal nomodifiable
endfunction

" tries to set the cursor to a line of the buffer list
function! <SID>BufferListGoto(line)
  if b:bufcount < 1 | return | endif
  if a:line < 1
    call cursor(1, 1)
  elseif a:line > b:bufcount
    call cursor(b:bufcount, 1)
  else
    call cursor(a:line, 1)
  endif
endfunction

" loads the selected buffer
function! <SID>LoadBuffer()
  " get the selected buffer
  let l:str = <SID>BufferListGetSelectedBuffer()
  " kill the buffer list
  bwipeout
  " ...and switch to the buffer number
  exec ":b " . l:str
endfunction

" deletes the selected buffer
function! <SID>BufferListDeleteBuffer()
  " get the selected buffer
  let l:str = <SID>BufferListGetSelectedBuffer()
  if !getbufvar(str2nr(l:str), '&modified')
    " kill the buffer list
    bwipeout
    " delete the selected buffer
    exec ":bdelete " . l:str
    " and reopen the list
    call <SID>BufferList(1)
  endif
endfunction

function! <SID>BufferListKeepBuffersForKeys(a:dict)
  for b in range(1, bufnr('$'))
    if buflisted(b) && !has_key(a:dict, b) && !getbufvar(b, '&modified')
      exe ':bdelete ' . b
    endif
  endfor
endfunction

" deletes all hidden buffers
" taken from: http://stackoverflow.com/a/3180886
function! <SID>BufferListDeleteHiddenBuffers()
  let l:visible = {}
  for t in range(1, tabpagenr('$'))
    for b in tabpagebuflist(t)
      let l:visible[b] = 1
    endfor
  endfor
  bwipeout
  call <SID>BufferListKeepBuffersForKeys(l:visible)
  call <SID>BufferList(1)
endfunction

" deletes all foreign (not tab friend) buffers
function! <SID>BufferListDeleteForeignBuffers()
  let l:friends = {}
  for t in range(1, tabpagenr('$'))
    silent! call extend(l:friends, gettabvar(t, 'BufferListTabFriends'))
  endfor
  bwipeout
  call <SID>BufferListKeepBuffersForKeys(l:friends)
  call <SID>BufferList(1)
endfunction

function! <SID>BufferListGetSelectedBuffer()
  " this is our string containing the buffer numbers in
  " the order of the list (separated by ':')
  let l:str = b:bufnumbers

  " remove all numbers BEFORE the one we want
  let l:i = 1 | while l:i < line(".") | let l:i += 1
    let l:str = strpart(l:str, stridx(l:str, ':') + 1)
  endwhile

  " and everything AFTER
  let l:str = strpart(l:str, 0, stridx(l:str, ':'))

  return l:str
endfunction

function! <SID>BufferListAddTabFriend()
  if !exists('t:BufferListTabFriends')
    let t:BufferListTabFriends = {}
  endif

  let l:current = bufnr('%')

  if getbufvar(l:current, '&modifiable') && getbufvar(l:current, '&buflisted') && l:current != bufnr("__BUFFERLIST__")
    let t:BufferListTabFriends[l:current] = 1
  endif
endfunction

function! <SID>BufferListToggleTabFriends()
  let s:tabfriendstoggle = !s:tabfriendstoggle
  bwipeout
  call <SID>BufferList(1)
endfunction

function! <SID>BufferListDetachTabFriend()
  let l:str = <SID>BufferListGetSelectedBuffer()
  if exists('t:BufferListTabFriends[' . l:str . ']') && (bufwinnr(str2nr(l:str)) == -1)
    bwipeout
    call remove(t:BufferListTabFriends, l:str)
    call <SID>BufferList(1)
  endif
endfunction
