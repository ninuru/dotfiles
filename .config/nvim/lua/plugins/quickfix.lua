-- auto-pairs maps <M-n>/<M-p> buffer-locally, shadowing the quickfix maps below
vim.g.AutoPairsShortcutJump = ""
vim.g.AutoPairsShortcutToggle = ""

vim.keymap.set("n", "<M-n>", "<Cmd>try | cnext | catch | cfirst | endtry<CR>zz")
vim.keymap.set("n", "<M-p>", "<Cmd>try | cprevious | catch | clast | endtry<CR>zz")
return {};
