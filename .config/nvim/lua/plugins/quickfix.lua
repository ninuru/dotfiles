vim.keymap.set("n", "<M-n>", "<Cmd>try | cnext | catch | cfirst | endtry<CR>zz")
vim.keymap.set("n", "<M-p>", "<Cmd>try | cprevious | catch | clast | endtry<CR>zz")
return {};
