" vim: fenc=utf-8 ft=vim et ts=2 sw=2 sts=0

" global options:
if !exists('g:markdown_fold_fenced_code')
  let g:makrdown_fold_override_foldtext = 0
endif

if !exists('g:markdown_fold_override_foldtext')
  let g:makrdown_fold_override_foldtext = 1
endif

" fold options:
setlocal syntax
setlocal foldmethod=expr
setlocal foldlevel=1
setlocal foldexpr=MarkdownFold(v:lnum)

if g:markdown_fold_override_foldtext
  setlocal foldtext=MarkdownFoldText()
endif

" functions:
function! MarkdownFold(lnum)
  let line = getline(a:lnum)
  let line_prev = getline(a:lnum - 1)
  let line_next = getline(a:lnum + 1)

  " headings:
  if line =~ '^#\{1,6}' && ! s:IsFenced(a:lnum)
    return '>' . s:HeadingDepth(a:lnum)
  endif

  " fenced code block:
    if line =~ '^\s*```' && line_prev == ''
      if g:markdown_fold_fenced_code
        return 'a1'
      else
        return '='
      endif
    elseif line =~ '^\s*```' && line_next == ''
      if g:markdown_fold_fenced_code
        return 's1'
      else
        return '='
      endif
    endif
  endif

  " html comment block:
  if line =~ '^\s*<!--' && line !~ '-->$'
    return 'a1'
  endif

  if line !~ '^\s*<!--' && line =~ '-->$'
    return 's1'
  endif

  " Ignore one-line comments.
  if line =~ '^\s*<!--' && line =~ '-->$'
    return '='
  endif

  " others:
  return '='
endfunction

function! MarkdownFoldText()
  let fold_line = getline(v:foldstart)
  let fold_line_prev = getline(v:foldstart-1)
  let fold_line_next = getline(v:foldstart+1)

  " headings:
  let pattern_headings = '^#\{1,6}'

  if fold_line =~ pattern_headings
    "let repl = repeat('-', s:HeadingDepth(v:foldstart))
    "let fold_text = substitute(fold_line, pattern_headings, repl, '')

    let fold_text = fold_line
  endif

  " fenced code block:
  let pattern_fenced_code = '^\s*```'

  if fold_line =~ pattern_fenced_code
    let repl = ''
    let code_type = substitute(fold_line, pattern_fenced_code, repl, '')
    if code_type == ''
      let fold_text = '[code block]'
    else
      let fold_text = '[code block:' . ' type = ' . code_type . ']'
    endif
  endif

  " multiple line comments:
  if fold_line =~ '^\s*<!--'
    let fold_text = substitute(fold_line, '^<!-*\s*', '', '')

    if fold_text == ''
      let fold_text = 'comment: ' . substitute(substitute(fold_line_next, '^\s*', '', ''), '\s*-*>$', '', '')
    else
      let fold_text = 'comment: ' . fold_text
    endif
  endif

  return fold_text
endfunction

function! s:HeadingDepth(lnum)
  let level=0
  let line = getline(a:lnum)
  let line_next = getline(a:lnum + 1)

  let pattern_headings = '^#\{1,6}'
  if line =~ pattern_headings
    let hashCount = len(matchstr(line, pattern_headings))
    if hashCount > 0
      let level = hashCount
    endif
  endif

  return level
endfunction

function! s:IsFenced(lnum)
  return s:HasSyntaxGroup(a:lnum, '\vmarkdown(Code|Highlight)')
endfunction

function! s:HasSyntaxGroup(lnum, target_group)
  let syntax_group = map(synstack(a:lnum, 1), 'synIDattr(v:val, "name")')
  for value in syntax_group
    if value =~ a:target_group
      return 1
    endif
  endfor
endfunction

" undo:
if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|setl foldexpr< foldmethod< foldtext<'
else
  let b:undo_ftplugin = 'setl foldexpr< foldmethod< foldtext<'
endif
