setlocal tabstop=4
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal expandtab
setlocal number showmatch
setlocal autoindent
let python_highlight_all = 1

let mapleader=","
let maplocalleader="\\"


let g:jedi#show_call_signatures = "0"
let g:jedi#goto_command = "<leader>d"
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
let g:jedi#completions_command = "<C-Space>"
let g:jedi#rename_command = "<leader>r"

set colorcolumn=80

let g:neomake_python_enabled_makers = ['flake8', 'pep8']
" E501 is line length of 80 characters
let g:neomake_python_flake8_maker = { 'args': ['--ignore=E501'], }
let g:neomake_python_pep8_maker = { 'args': ['--max-line-length=105'], }
