return {
    {
        "nvim-telescope/telescope.nvim",

        dependencies = {
            "nvim-lua/plenary.nvim"
        },

        config = function()
            require('telescope').setup({
                pickers = {
                    find_files = {
                        follow = true,
                    }
                },
                extensions = {
                    recent_files = {
                        only_cwd = true,
                    }
                }
            })

            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
            vim.keymap.set('n', '<leader>tt', builtin.diagnostics, {})
            vim.keymap.set('n', '<leader>pe', builtin.lsp_dynamic_workspace_symbols, {})
            vim.keymap.set('n', '<leader>pws', function()
                local word = vim.fn.expand("<cword>")
                builtin.grep_string({ search = word })
            end)
            vim.keymap.set('n', '<leader>pWs', function()
                local word = vim.fn.expand("<cWORD>")
                builtin.grep_string({ search = word })
            end)
            vim.keymap.set('n', '<leader>ps', function()
                builtin.grep_string({ search = vim.fn.input("Grep > ") })
            end)
            vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
        end
    },

    {
        "smartpde/telescope-recent-files",
        dependencies = {
            "nvim-telescope/telescope.nvim"
        },

        config = function()
            require("telescope").load_extension("recent_files")

            vim.api.nvim_set_keymap("n", "<leader>e",
            [[<cmd>lua require('telescope').extensions.recent_files.pick()<CR>]],
            {noremap = true, silent = true})
        end
    }
}

