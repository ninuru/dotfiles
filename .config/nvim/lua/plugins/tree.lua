return {
    {
        "nvim-tree/nvim-tree.lua",
        config = function()
            -- disable netrw at the very start of your init.lua
            -- vim.g.loaded_netrw = 1
            -- vim.g.loaded_netrwPlugin = 1

            -- OR setup with some options
            require("nvim-tree").setup({
                update_focused_file = {
                    enable      = true,
                    update_cwd  = false,
                    ignore_list = {}
                },
                sort = {
                    sorter = "case_sensitive",
                },
                view = {
                    width = 40,
                },
                renderer = {
                    group_empty = true,
                },
                filters = {
                    dotfiles = true,
                },
            })
        end
    }
}
