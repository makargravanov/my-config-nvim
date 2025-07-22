if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/nvim/plugged')

" LSP и автодополнение
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Подсветка синтаксиса
Plug 'sheerun/vim-polyglot'

" Файловый менеджер
Plug 'preservim/nerdtree'

" Статусная строка
Plug 'vim-airline/vim-airline'

call plug#end()

set number
syntax enable
set tabstop=4
set shiftwidth=4
set expandtab
filetype plugin indent on

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nnoremap <silent> K :call CocAction('doHover')<CR>

"автокомплит
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

"автозапуск NERDTree
autocmd VimEnter * NERDTree | wincmd p

"горячие клавиши
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
