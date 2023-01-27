<!-- vim: set fenc=utf-8 ft=markdown et ts=2 sw=2 sts=0: -->

# Custom Fold

This plugin provides custom fold expr and fold text.
The list of current available file type is below:

- sh
- markdown
- tex (LaTeX documents)
- vim

## sh

in preparation

## markdown

This is a minor customization to [masukomi/vim-markdown-folding](https://github.com/masukomi/vim-markdown-folding).
This plugin determines the fold level based on following rules.

- **heading depth**:
   Vim uses the heading depth as the fold level
   if the current line is contained in H1, H2, ..., H6 headings
   with the following exceptions.

- **fenced code blocks**:
   Each fenced code blocks are folded (i.e. foldlevel = depth + 1).

   To enable this feature, add the following line to your `.vimrc`.

   ```vim
   let g:markdown_fold_fenced_code = 1
   ```

- **multiple line comments**:
   Similarly, each multiple line comments are folded.
   However, every one-line comments are ignored.

For more customization, have a look at the [doc/markdown-fold.txt](doc/markdown-fold.txt).

## tex

This is a minor customization to [matze/vim-tex-fold](https://github.com/matze/vim-tex-fold).
This plugin determines the fold level based on following rules.

- **section level**:
  vim uses the section level as the fold level.

- **blocks bounded by begin and end**:
  Each blocks between `/begin{} and \end{}` are folded.
  As stated below, you can specify which environments to fold.

- **custom fold markers**:
  Further, you can define fold by the fold markers
  which you specify.

### Configuration

- If you allow vim to fold by fold markers, the default fold marker is `{{{` and `}}}`.
  However, sometimes triple `{{{` or `}}}` appear in a LaTeX document,
  and this gives rise to the folding problem by fold markers.
  You can specify custom fold markers besides `{{{` and `}}}` by `g:tex_fold_marker`.

  For example, to use `<<<` and `>>>` as custom fold markers like

     ```tex
     % comment <<<
     foo bar
     % >>>
     ```

  add the following lines to your `.vimrc`:

     ```vim
     let g:tex_fold_allow_marker = 1
     let g:tex_fold_custom_marker = ['<<<','>>>']
     ```

- By default, any environment blocks are not folded.
  To specify environments to be folded, add the following line to your `.vimrc`.

  ```vim
  let g:tex_fold_envs = ['dfn','thm','prop','lem','proof']
  ```

For more customization, have a look at the [doc/tex-fold.txt](doc/tex-fold.txt).

## vim

in preparation

## Help

You can read help documents by `:h ft-fold.txt` with replacing `ft`
with the corresponding file type.

## License

This plugin is licensed under MIT license.
