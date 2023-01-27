" vim: fenc=utf-8 ft=vim et ts=2 sw=2 sts=0

" global options:
if !exists('g:tex_fold_override_foldtext')
  let g:tex_fold_override_foldtext = 1
endif

if !exists('g:tex_fold_sec_char')
  let g:tex_fold_sec_char = '§'
endif

if !exists('g:tex_fold_env_char')
  let g:tex_fold_env_char = '❯'
endif

if !exists('g:tex_fold_allow_marker')
  let g:tex_fold_allow_marker = 0
endif

if exists('g:tex_fold_allow_marker')
  if !exists('g:tex_fold_marker')
    let g:tex_fold_marker = ['{{{','}}}']
  endif
endif

if !exists('g:tex_fold_envs')
  let g:tex_fold_envs = []
endif


" fold options:
setlocal foldmethod=expr
setlocal foldexpr=TexFold(v:lnum)

if g:tex_fold_override_foldtext
  setlocal foldtext=TexFoldText()
endif


" functions:
function! TexFold(lnum)
  let line = getline(a:lnum)

  if ! empty('g:tex_fold_envs')
    let envs = '\(' . join(g:tex_fold_envs, '\|') . '\)'
  endif

  if line =~ '^\s*\\section'
    return '>1'
  endif

  if line =~ '^\s*\\subsection'
    return '>2'
  endif

  if line =~ '^\s*\\subsubsection'
    return '>3'
  endif

  " Decrease fold level at the end of section etc:
  "if line =~ '^%\send\sof\s\(sub\)*section'
  "  return 's1'
  "endif

  if exists('envs')
    if line =~ '^\s*\\begin{' . envs
      return 'a1'
    endif

    if line =~ '^\s*\\end{' . envs
      return 's1'
    endif
  endif

  if g:tex_fold_allow_marker
    if line =~ '^[^%]*%.*' . g:tex_fold_marker[0]
        return 'a1'
   endif

    if line =~ '^[^%]*%.*' . g:tex_fold_marker[1]
      return 's1'
    endif
  endif

  return '='
endfunction

function! TexFoldText()
  let fold_line = getline(v:foldstart)

  if fold_line =~ '^\s*\\\(sub\)*section'
    let pattern = '\\\(sub\)*section\*\={\([^}]*\)}'
    let repl = repeat(g:tex_fold_sec_char, foldlevel(v:foldstart))  . ' \2'
  elseif fold_line =~ '^\s*\\begin'
    let pattern = '\\begin{\([^}]*\)}\s*\(\[*[^]*\]*\)\s*\(%[^%]*\)'
    let repl = g:tex_fold_env_char . ' \1' . ' \2'
  elseif g:tex_fold_allow_marker && fold_line =~ '^[^%]*%*.*' . g:tex_fold_marker[0]
    let pattern = '^[^%]*\(%*.*\)' . g:tex_fold_marker[0]
    let repl = '\1'
  endif

  let line = substitute(fold_line, pattern, repl, '') . ' '
  return line
endfunction


" undo:
if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|setl foldexpr< foldmethod< foldtext<'
else
  let b:undo_ftplugin = 'setl foldexpr< foldmethod< foldtext<'
endif
