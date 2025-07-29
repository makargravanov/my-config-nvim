if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/nvim/plugged')

" LSP и автодополнение
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Тема JB
Plug 'nickkadutskyi/jb.nvim'

" Улучшенная подсветка синтаксиса
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-context'

" Файловый менеджер
Plug 'preservim/nerdtree'

" Статусная строка
Plug 'vim-airline/vim-airline'

" Отладка
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'theHamsta/nvim-dap-virtual-text' " Показ значений переменных

call plug#end()


" Настройка темы JB
lua <<EOF
require("jb").setup()
EOF

" Включение темы
set termguicolors
colorscheme jb

let mapleader = " "

" Настройка Tree-sitter для улучшенной подсветки
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"c", "cpp", "lua", "python", "rust", "markdown"},
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true },
}
EOF

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


" ------------------------------------- НАСТРОЙКА LLDB
lua <<EOF
local dap = require('dap')

-- Проверяем доступность codelldb
local codelldb_path = '/usr/bin/codelldb'
if vim.fn.executable(codelldb_path) == 1 then
  dap.adapters.codelldb = {
    type = 'server',
    port = '${port}',
    executable = {
      command = codelldb_path,
      args = {'--port', '${port}'},
    }
  }

  -- Конфигурация для C/C++
  dap.configurations.cpp = {
    {
      name = "Launch Debug",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = true,
      args = {},
    },
  }
  dap.configurations.c = dap.configurations.cpp
else
  vim.notify("codelldb not found at: " .. codelldb_path, vim.log.levels.WARN)
end

vim.api.nvim_set_hl(0, "blue",   { fg = "#3d59a1" }) 
vim.api.nvim_set_hl(0, "green",  { fg = "#9ece6a" }) 
vim.api.nvim_set_hl(0, "yellow", { fg = "#FFFF00" }) 
vim.api.nvim_set_hl(0, "orange", { fg = "#f09000" })
vim.api.nvim_set_hl(0, "red",    { fg = "#ff0000" })

vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = 'red', linehl = 'red', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '->', texthl = 'green', linehl = 'green', numhl = '' })

-- Инициализация DAP UI только если плагин установлен
local ok, dapui = pcall(require, 'dapui')
if ok then
  dapui.setup()
 
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end
end
EOF

" Хоткеи отладки
nnoremap <silent> <F5> :lua require'dap'.continue()<CR>
nnoremap <silent> <F10> :lua require'dap'.step_over()<CR>
nnoremap <silent> <F11> :lua require'dap'.step_into()<CR>
nnoremap <silent> <F12> :lua require'dap'.step_out()<CR>
nnoremap <silent> <leader>b :lua require'dap'.toggle_breakpoint()<CR>
nnoremap <silent> <leader>B :lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
nnoremap <silent> <leader>dr :lua require'dap'.repl.open()<CR>
nnoremap <silent> <leader>du :lua require'dapui'.toggle()<CR>
