" vim: fenc=utf-8 ft=vim et ts=2 sw=2 sts=0

" global options:
if !exists('g:vim_fold_override_foldtext')
  let g:vim_fold_override_foldtext = 1
endif


" fold options:
setlocal foldmethod=expr
setlocal foldexpr=VimFold(v:lnum)

if g:vim_fold_override_foldtext
  setlocal foldtext=VimFoldText()
endif


" functions:
function! VimFold (lnum) abort
  let line = getline(a:lnum)
  let line_prev = getline(a:lnum - 1)
  let line_next = getline(a:lnum + 1)

  " function block:
  let expr_function_beg = '^\s*function'
  let expr_function_end = '^\s*endfunction$'

  if line =~ expr_function_beg
    return 'a1'
  elseif line =~ expr_function_end
    return 's1'
  endif


  " section comment block:
  "if line =~ '^\s*\"' && line =~ ':$'
  "  return 'a1'
  "endif

  "if line == '' && line_next =~ '^\s*\"' && line_next =~ ':$'
  "  return 's1'
  "endif

  return '='
endfunction

function! VimFoldText () abort
  let fold_line = getline(v:foldstart)

  " format fold text:
  let fold_marker = split(&foldmarker, ",")
  let fold_marker_start = fold_marker[0]

  let repl_pattern_list = ['^\s*"\s*', fold_marker_start . '[0-9]$']
  let repl_text = ''

  let repl = fold_line

  for repl_pattern in repl_pattern_list
    let repl = substitute(repl, repl_pattern, repl_text, '')
  endfor

  " replace fold text if the fold start line is only marker:
  if repl == ''
    let repl = getline(v:foldstart + 1)
  endif

  " return foldtext:
  let fold_line_count = v:foldend - v:foldstart + 1
  let fold_text_header = repeat('-', foldlevel(v:foldstart)) . ' '
  let fold_text_footer = fold_line_count . ' lines:'
  let fold_text = fold_text_header . repl . fold_text_footer

  return fold_text

endfunction


" undo:
if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|setl foldexpr< foldmethod< foldtext<'
else
  let b:undo_ftplugin = 'setl foldexpr< foldmethod< foldtext<'
endif
