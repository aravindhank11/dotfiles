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

" Right side word limit "
set colorcolumn=100
hi ColorColumn ctermbg=red guibg=grey

" highlight ColorColumn term=reverse ctermbg=0 guibg=#081c23
set nocscopeverbose

" Cursor Mode Settings
let &t_SI.="\e[5 q" "SI = INSERT mode
let &t_SR.="\e[5 q" "SR = REPLACE mode
let &t_EI.="\e[5 q" "EI = NORMAL mode (ELSE)

"***************************** Basic Key mappings ******************************"
" Go to start and end of line using Ctrl+A and Ctrl+E "
imap <C-e> <ESC>A
imap <C-a> <ESC>I
nnoremap <C-e> <ESC>A
nnoremap <C-a> <ESC>I

" Tabs "
nnoremap te :tabedit 
nnoremap <C-j> :tabprevious<CR>
nnoremap <C-k> :tabnext<CR>
augroup quickfix_tab | au!
    "Ref: https://vi.stackexchange.com/a/27795
    au filetype qf nnoremap <buffer> <C-t> <C-w><CR><C-w>T
augroup END


" use system clipboard by default
set clipboard=unnamedplus

set incsearch " incremental search (as string is being typed)
set history=8192 " more history

set pastetoggle=<leader>p

let g:relative_number_toggle = 0
set relativenumber
function! ToggleRelativeNumber()
    if(g:relative_number_toggle == 0)
        set relativenumber!
        let g:relative_number_toggle = 1
    else
        set relativenumber
        let g:relative_number_toggle = 0
    endif
endfunction
map <leader>n :call ToggleRelativeNumber()<CR>

let g:mouse_toggle = 0
set mouse=r
function! ToggleMouse()
    if(g:mouse_toggle == 0)
        set mouse=a
        let g:mouse_toggle = 1
        echo "Mouse selection within vim"
    else
        set mouse=r
        let g:mouse_toggle = 0
        echo "Mouse selection global"
    endif
endfunction
map <C-c> :call ToggleMouse()<CR>

vmap <C-y> "+y

" Mouse resizing for splits
" NOTE: This will work only with mouse=a
set ttymouse=xterm2

"****************************** Plugins ******************************"
call plug#begin('~/.vim/plugged')

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

" Fold "
Plug 'https://github.com/tmhedberg/SimpylFold.git'

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

call plug#end()

"***************************** Pluggin Key mappings and sets ******************************"
" Jump between hunks
nmap <Leader>gn <Plug>GitGutterNextHunk  " git next
nmap <Leader>gp <Plug>GitGutterPrevHunk  " git previous

" fuzzy finder "
map <C-f> <Esc><Esc>:Files!<CR>
inoremap <C-f> <Esc><Esc>:BLines!<CR>
map <C-g> <Esc><Esc>:BCommits!<CR>

" git blame for current line "
nnoremap <Leader>s :<C-u>call gitblame#echo()<CR>

" git colorful what changes am I making "
set updatetime=1000
let g:gitgutter_max_signs = 500
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

" fold "
set nofoldenable
set foldmethod=syntax
filetype plugin on
filetype indent on
" Fold and unfold with mouse "
" noremap <3-LeftMouse> za

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
nnoremap <C-n> :NERDTreeToggle<CR>
