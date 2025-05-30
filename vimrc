"****************************** Basic set **********************************"
set splitbelow
set splitright
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set novisualbell
set title
set number
set smarttab autoindent smartindent cindent
set hlsearch
set incsearch   " search as characters are entered
set background=dark
" Search dir you are currently in and then recursively
set path=.,,**
set backspace=indent,eol,start
set ignorecase
set cursorline
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" Right side word limit "
set colorcolumn=80
hi ColorColumn ctermbg=red guibg=grey

" highlight ColorColumn term=reverse ctermbg=0 guibg=#081c23
set nocscopeverbose

" Cursor Mode Settings
" let &t_SI.="\e[5 q" "SI = INSERT mode
let &t_SR.="\e[5 q" "SR = REPLACE mode
let &t_EI.="\e[5 q" "EI = NORMAL mode (ELSE)

"***************************** Basic Key mappings ******************************"
" Go to start and end of line using Ctrl+A and Ctrl+E "
map <C-a> <Esc>I
inoremap <C-a> <Esc>I
map <C-e> <Esc>A
inoremap <C-e> <Esc>A

" Tabs - gap at last is intentional "
nnoremap te :tabedit 
nnoremap <C-j> :tabprevious<CR>
nnoremap <C-k> :tabnext<CR>
augroup quickfix_tab | au!
    "Ref: https://vi.stackexchange.com/a/27795
    au filetype qf nnoremap <buffer> <C-t> <C-w><CR><C-w>T
augroup END

set incsearch " incremental search (as string is being typed)
set history=8192 " more history

set pastetoggle=<leader>p

" System Copy (Ctrl + C) and Paste (Ctrl + V)
set clipboard=unnamed
vnoremap <C-v> "+p
vnoremap <C-c> "+y

" Mouse resizing for splits
" set mouse=a
set ttymouse=xterm2

"****************************** Plugins ******************************"
call plug#begin('~/.vim/plugged')

" Copilot "
Plug 'https://github.com/github/copilot.vim.git'

" Git stuffs "
Plug 'https://github.com/tpope/vim-fugitive.git'
Plug 'https://github.com/zivyangll/git-blame.vim.git'

" What branch am I in ? "
Plug 'https://github.com/vim-airline/vim-airline.git'
Plug 'https://github.com/vim-airline/vim-airline-themes.git'

" What changes am I making in git tree "
Plug 'https://github.com/airblade/vim-gitgutter.git'

" Fuzzy finder "
Plug 'https://github.com/junegunn/fzf.git'
Plug 'https://github.com/junegunn/fzf.vim.git'

" Notes maker "
Plug 'https://github.com/vimwiki/vimwiki.git'

" ripgrep "
Plug 'https://github.com/jremmen/vim-ripgrep.git'
Plug 'https://github.com/mileszs/ack.vim.git'

" color trailing white space "
Plug 'https://github.com/ntpeters/vim-better-whitespace.git'

" cscope "
Plug 'https://github.com/dr-kino/cscope-maps.git'

" Nerd Tree "
Plug 'https://github.com/preservim/nerdtree.git'

" Python syntax highlight "
Plug 'https://github.com/python-mode/python-mode.git'

" Async lint "
Plug 'https://github.com/dense-analysis/ale.git'

call plug#end()

"***************************** Pluggin Key mappings and sets ******************************"
" fuzzy finder "
map <C-f> <Esc><Esc>:Files<CR>
inoremap <C-f> <Esc><Esc>:BLines!<CR>
map <C-g> <Esc><Esc>:RG<CR>
" map <C-g> <Esc><Esc>:BCommits!<CR>

" git blame for current line "
nnoremap <Leader>s :<C-u>call gitblame#echo()<CR>

" git colorful what changes am I making "
set updatetime=1000
let g:gitgutter_max_signs = 1000
let g:gitgutter_map_keys = 0
let g:gitgutter_override_sign_column_highlight = 0
highlight clear SignColumn
highlight GitGutterAdd ctermfg=2
highlight GitGutterChange ctermfg=3
highlight GitGutterDelete ctermfg=1
highlight GitGutterChangeDelete ctermfg=4

" Coloring "
syntax on
set t_Co=256
let g:airline_theme='badwolf'
highlight Visual cterm=NONE ctermbg=0 ctermfg=Grey guibg=Grey

" Coloring for vimdiff "
highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffDelete cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffChange cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffText   cterm=bold ctermfg=10 ctermbg=88 gui=none guifg=bg guibg=Red

" ripgrep "
let g:ackprg = 'rg --vimgrep --smart-case'
" Auto close the Quickfix list after pressing '<enter>' on a list item
let g:ack_autoclose = 1
" Any empty ack search will search for the work the cursor is on
let g:ack_use_cword_for_empty_search = 1
" Maps <leader>/ so we're ready to type the search keyword
nnoremap <Leader>/ :Ack!<Space>o

" cscope"
" Ref: https://learnvimscriptthehardway.stevelosh.com/chapters/52.html "
function! UpdateCscopeDB()
    :!cscope -Rbq
    :cs reset
    :redraw!
    echo "Updated cscopedb"
endfunction
command UpdateDb call UpdateCscopeDB()

" show function name on status bar "
" Ref: https://stackoverflow.com/a/23259759/9328077 "
fun! ShowFuncName()
  let lnum = line(".")
  let col = col(".")
  echohl ModeMsg
  echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
  echohl None
  call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfun
map f :call ShowFuncName() <CR>

" NerdTree Toggle
nnoremap <C-n> :NERDTree %<CR>

" Spell-check Markdown files and Git Commit Messages
autocmd FileType markdown setlocal spell
autocmd FileType gitcommit setlocal spell

" Enable dictionary auto-completion in Markdown files and Git Commit Messages
autocmd FileType markdown setlocal complete+=kspell
autocmd FileType gitcommit setlocal complete+=kspell

" Linter
let g:ale_linters={
\    'python': ['pylint'],
\}
let g:ale_python_pylint_options = '--rcfile ~/.pylintrc'

" Intelli-sense
set encoding=utf-8
set nobackup
set nowritebackup
set updatetime=300
" set signcolumn=yes
