" vim: fenc=utf-8 ft=vim et ts=2 sw=2 sts=0

" global options:
if !exists('g:snippets_fold_override_foldtext')
  let g:snippets_fold_override_foldtext = 1
endif


" fold options:
setlocal foldmethod=expr
setlocal foldexpr=SnippetsFold(v:lnum)

if g:snippets_fold_override_foldtext
  setlocal foldtext=SnippetsFoldText()
endif


" functions:
function! SnippetsFold (lnum) abort
  let line = getline(a:lnum)

  " function block:
  let expr_snippet_beg = '^snippet'
  let expr_snippet_end = '^endsnippet'

  if line =~ expr_snippet_beg
    return 'a1'
  elseif line =~ expr_snippet_end
    return 's1'
  endif

  return '='

endfunction

function! SnippetsFoldText () abort
  let fold_line = getline(v:foldstart)
  return fold_line
endfunction


" undo:
if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|setl foldexpr< foldmethod< foldtext<'
else
  let b:undo_ftplugin = 'setl foldexpr< foldmethod< foldtext<'
endif
