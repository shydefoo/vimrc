nnoremap <leader>jdr :rightbelow vertical YcmCompleter GoToDefinition<CR>
nnoremap <leader>jd :YcmCompleter GoToDefinition<CR>
nnoremap <leader>jc :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>jr :YcmCompleter GoToReferences<CR>
nnoremap <leader>jt :YcmCompleter GetType<CR>
nnoremap <leader>jw :YcmCompleter GetDoc<CR>
nnoremap <leader>yr :YcmCompleter RefactorRename

" mapping for go
autocmd FileType go nnoremap <buffer> <leader>jd :GoDef<CR>

set encoding=utf8
let g:ycm_goto_buffer_command = 'split'
" set linespace
set linespace=3


" ale fixers
let g:ale_fixers = {
\   'javascript': ['prettier', 'eslint'],
\   'python': ['black', 'isort'],
\   'go':['gofmt', 'goimports'],
\    'xml': ['xmllint']
\}


let g:ale_linters = {
\   'javascript': ['eslint', 'prettier'],
\   'python': ['flake8', 'mypy'],
\   'go': ['golangci-lint'],
\}

let g:black_skip_string_normalization = 1
map <leader>fx :ALEFix<CR>

let g:ale_set_highlights = 1
let g:ale_fix_on_save = 1
let g:ale_lint_on_text_changed = 0
let g:ale_open_list = 0
let g:ale_lint_on_insert_leave = 0

" use goimports for formatting
let g:go_fmt_command = "goimports"
let g:go_def_mode = 'godef'

" turn highlighting on
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

let g:xml_syntax_folding = 0 
let g:vim_markdown_folding_disabled = 1

" disable other diagnostic tools for java
let g:syntastic_java_checkers = []

" ycm pyenv compatibility
" let g:ycm_path_to_python_interpreter = "~/.pyenv/shims/python3.6"
" set working directory to git project root
" or directory of current file if not git project
function! SetProjectRoot()
  " default to the current file's directory
  lcd %:p:h
  let git_dir = system("git rev-parse --show-toplevel")
  " See if the command output starts with 'fatal' (if it does, not in a git repo)
  let is_not_git_dir = matchstr(git_dir, '^fatal:.*')
  " if git project, change local directory to git project root
  if empty(is_not_git_dir)
    lcd =git_dir
  endif
endfunction

" netrw: follow symlink and set working directory
autocmd CursorMoved silent * call SetProjectRoot() 
map <leader>spr :call SetProjectRoot()<CR>

let g:airline_theme = "base16_spacemacs"

map <leader><c-p> :ALEHover<CR>
let g:syntastic_python_pylint_post_args="--max-line-length=120"

" display current filepath
map <leader>fp :echo @%<cr>
" set guifont=IBM\ Plex\ Mono:h15

" auto reload when file changes on disk
" autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
" notification when file changes
" autocmd FileChangedShellPost *
"  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" display ale errors in statusline
let g:airline#extensions#ale#enabled = 1
map <leader>fmm :set foldmethod=marker<CR>

set redrawtime=10000

nmap <silent> <leader><C-k> <Plug>(ale_previous_wrap)
nmap <silent> <leader><C-j> <Plug>(ale_next_wrap)


" auto complete of /*
vnoremap $c <esc>`>a/*<esc>`<i*/<esc>
" insert multi line comments for go
inoremap $c /**/<esc>hi<cr><cr><esc>ki


let g:fugitive_gitlab_domains = ['https://github.wdf.sap.corp']
set diffopt+=vertical
set tabstop=2
set shiftwidth=2

set mouse=a

let g:localvimrc_debug = 0

" for gbrowse
let g:github_enterprise_urls = ['https://github.wdf.sap.corp']

if has('nvim')
  tnoremap <Esc> <C-\><C-n>
endif

" for fzf
set rtp+=/usr/local/opt/fzf
map <leader>f :FZF<CR>

hi TabLine      guifg=#999 guibg=#222 gui=none ctermfg=254 ctermbg=238 cterm=none
hi TabLineSel   guifg=#abb2bf guibg=#3e4452 gui=bold ctermfg=231 ctermbg=235 cterm=bold
hi TabLineFill  guifg=#999 guibg=#222 gui=none ctermfg=254 ctermbg=238 cterm=none

" vim-signature
nnoremap <leader>hm :SignatureToggleSigns<CR>
let g:SignatureMarkTextHL = 'CtrlPdark'
let g:SignatureMap = {
  \ 'Leader'             :  "m",
  \ 'PlaceNextMark'      :  "m,",
  \ 'ToggleMarkAtLine'   :  "m.",
  \ 'PurgeMarksAtLine'   :  "m-",
  \ 'DeleteMark'         :  "dm",
  \ 'PurgeMarks'         :  "m<Space>",
  \ 'PurgeMarkers'       :  "m<BS>",
  \ 'GotoNextLineAlpha'  :  "']",
  \ 'GotoPrevLineAlpha'  :  "'[",
  \ 'GotoNextSpotAlpha'  :  "`]",
  \ 'GotoPrevSpotAlpha'  :  "`[",
  \ 'GotoNextLineByPos'  :  "]'",
  \ 'GotoPrevLineByPos'  :  "['",
  \ 'GotoNextSpotByPos'  :  "]`",
  \ 'GotoPrevSpotByPos'  :  "[`",
  \ 'GotoNextMarker'     :  "]-",
  \ 'GotoPrevMarker'     :  "[-",
  \ 'GotoNextMarkerAny'  :  "]=",
  \ 'GotoPrevMarkerAny'  :  "[=",
  \ 'ListBufferMarks'    :  "m/",
  \ 'ListBufferMarkers'  :  "m?"
  \ }

" ack
let g:ack_use_dispatch = 1


" cwindow
nnoremap <leader>c :ccl<CR>
nnoremap <leader>cw :cope<CR>


" nerdtree
let g:NERDTreeWinPos = "right"

set updatetime=300
