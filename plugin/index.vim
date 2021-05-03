let s:pendingHighlightTimer = 0
" set this to a long delay to 'disable' highlighting
let g:highlightWordDelay = 300

hi WordUnderCursor guifg=NONE guibg=#484848

fun! s:HighlightWordUnderCursor(timerId)
  let l:isNormalMode = mode() == 'n'
  if !l:isNormalMode
    return
  endif

  " prevent overriding of search highlights under cursor
  if v:hlsearch && get(searchcount(), 'exact_match', 0) > 0
    return
  endif

  exe printf(
    \ 'match WordUnderCursor /\V\<%s\>/',
    \ escape(expand('<cword>'), '/\'))
endfun

augroup HighlightWordUnderCursor
  autocmd!
  " clear previous matches and cancel any pending highlights
  autocmd WinLeave,CmdWinEnter,CmdLineEnter,CursorMoved,InsertEnter *
    \ match none
    \ | call timer_stop(s:pendingHighlightTimer)
  autocmd CursorHold *
    \ let s:pendingHighlightTimer = timer_start(
      \ g:highlightWordDelay,
      \ function('s:HighlightWordUnderCursor'))
augroup END
