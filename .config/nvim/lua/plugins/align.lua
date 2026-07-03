
return {
    "junegunn/vim-easy-align",
    config = function()
        -- Start interactive EasyAlign in visual mode (e.g. vipga)
        vim.keymap.set("x", "ga", "<Plug>(EasyAlign)")
        -- Start interactive EasyAlign for a motion/text object (e.g. gaip)
        vim.keymap.set("n", "ga", "<Plug>(EasyAlign)")

        -- Emacs-style `:align` command, e.g. `:align =` or `:align /;/`
        vim.cmd("cnoreabbrev align EasyAlign")
    end
}
