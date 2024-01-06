function! ShowPopupNotification(msg, hl_group) abort
  " Log the message to :messages
  execute 'echomsg ' . shellescape(a:msg)

  if has('nvim')
    let l:buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(l:buf, 0, -1, v:true, [a:msg])
    let l:win_opts = {
          \ 'relative': 'editor',
          \ 'anchor': 'NW',
          \ 'width': max([20, len(a:msg)]),
          \ 'height': 1,
          \ 'col': winwidth(0) - 2,
          \ 'row': 1,
          \ 'style': 'minimal',
          \ 'border': 'single',
          \ }
    let l:win = nvim_open_win(l:buf, v:true, l:win_opts)
    call nvim_win_set_option(l:win, 'winhl', 'Normal:' . a:hl_group)
    call timer_start(3000, {-> nvim_win_close(l:win, v:true)})
  else
    call popup_notification(a:msg, {
          \ 'col': winwidth(0)-2,
          \ 'anchor': 'NW',
          \ 'minwidth': 20,
          \ 'time': 3000,
          \ 'highlight': a:hl_group,
          \ 'borderchars': ['─', '│', '─', '│', '╭', '╮', '╯', '╰'],
          \ 'close': 'click',
          \ 'padding': [0,1,0,1],
          \ })
  endif
endfunction

function! which_key#error#report(err_msg) abort
  if get(g:, 'which_key_error_popup', 0) == 1
    call ShowPopupNotification('[which-key] '.a:err_msg, 'ErrorMsg')
  else
    echohl ErrorMsg
    echom '[which-key] '.a:err_msg
    echohl None
  endif
endfunction

function! which_key#error#undefined_key(key) abort
  if get(g:, 'which_key_error_popup', 0) == 1
    call ShowPopupNotification('[which-key] '.a:key.' is undefined', 'ErrorMsg')
  else
    echohl ErrorMsg
    echom '[which-key] '.a:key.' is undefined'
    echohl None
  endif
endfunction

function! which_key#error#missing_mapping() abort
  if get(g:, 'which_key_error_popup', 0) == 1
    call ShowPopupNotification('[which-key] Fail to execute, no such mapping', 'ErrorMsg')
  else
    echohl ErrorMsg
    echom '[which-key] Fail to execute, no such mapping'
    echohl None
  endif
endfunction

