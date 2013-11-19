" runner.vim
" Author: Nick Ulle
" Description:
"   A little plugin for running interpreted code in REPL environments.
"   Inspired by slime.vim.
" License:

" Ensure the plugin is only loaded once.
if exists("g:loaded_runner")
    finish
endif
let g:loaded_runner = 1

" Map the functions to some keys.
if !hasmapto('<plug>RunnerRunLine')
    map <unique> <leader>o <plug>RunnerRunLine
endif

function s:RunLine()
    let line = getline('.')
    echo system("screen -S bashscreen -p 0 X stuff '" . line . "'")
    "substitute(line, "'", "'\\\\''", 'g') . "'")
endfunction

noremap <unique> <plug>RunnerRunLine <sid>Run

