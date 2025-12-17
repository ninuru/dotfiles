local config = require('../config')

return {
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    },
    { "projekt0n/github-nvim-theme" },
    { "sainnhe/gruvbox-material" },
    { "morhetz/gruvbox" },
    { "rose-pine/neovim" },
    { "rebelot/kanagawa.nvim" },
    { "arturgoms/moonbow.nvim", },
    { "aktersnurra/no-clown-fiesta.nvim", },
    { "morhetz/gruvbox", },
    { "folke/tokyonight.nvim", },
    { "tiagovla/tokyodark.nvim", },
    { "AlexvZyl/nordic.nvim", },
    { "Mofiqul/vscode.nvim", },
    { "oxfist/night-owl.nvim", },
    { "vague2k/vague.nvim", },
    { "ficcdaf/ashen.nvim", },
    { "navarasu/onedark.nvim", },
    { "olimorris/onedarkpro.nvim", },
    {
        "blazkowolf/gruber-darker.nvim",
        config = function()
            vim.api.nvim_create_autocmd("ColorScheme", {
                pattern = "gruber-darker",
                callback = function()
                    vim.cmd("highlight String gui=NONE")
                    vim.cmd("highlight GruberDarkerYellowBold gui=NONE")
                end,
            })
        end
    },
    {
        "Mofiqul/dracula.nvim",
        dependencies = { "rktjmp/lush.nvim" }
    },
    {
        "EdenEast/nightfox.nvim",
        config = function()
            require('nightfox').setup({
                options = {
                    transparent = false,     -- Disable setting background
                    terminal_colors = false, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
                },
                palettes = {
                    terafox = {
                        bg1 = "#1c1c1c",  -- Black background
                        bg0 = "#2c2c2c",  -- Alt backgrounds (floats, statusline, ...)
                        bg3 = "#2c2c2c",  -- 55% darkened from stock
                        sel0 = "#2c2c2c", -- 55% darkened from stock
                    },
                },
            })
        end,
    },
    {
        "metalelf0/jellybeans-nvim",
        dependencies = { "rktjmp/lush.nvim" },
        config = function()
            vim.api.nvim_create_autocmd("ColorScheme", {
                pattern = "jellybeans-nvim",
                callback = function()
                    vim.api.nvim_set_hl(0, "special", { fg = "#7998c2" })
                    vim.api.nvim_set_hl(0, "type", { fg = "#ffb964" })
                end,
            })
        end
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {
            no_italic = true,
            term_colors = true,
            transparent_background = false,
            styles = {
                comments = {},
                conditionals = {},
                loops = {},
                functions = {},
                keywords = {},
                strings = {},
                variables = {},
                numbers = {},
                booleans = {},
                properties = {},
                types = {},
            },
            color_overrides = {
                all = {
                    base = "#181926",
                },
                -- mocha = {
                --     base = "#000000",
                --     mantle = "#000000",
                --     crust = "#000000",
                -- },
            },
            integrations = {
            },
        },

    },
    {
        "ayu-theme/ayu-vim",
        priority = -100,
        config = function()
            -- vim.api.nvim_set_hl(0, "@lsp.type.namespace", { fg = "#e5e5e5" })      -- Color for module paths in imports
            -- vim.api.nvim_set_hl(0, "@lsp.type.struct.rust", { fg = "#f6993f" })    -- Color for module paths in imports
            -- vim.api.nvim_set_hl(0, "@lsp.type.interface.rust", { fg = "#f6993f" }) -- Color for module paths in imports
            --
            -- vim.api.nvim_set_hl(0, "@lsp.type.namespace.java", { fg = "#e5e5e5" })
            -- vim.api.nvim_set_hl(0, "@lsp.type.class.java", { fg = "#f6993f" })
            -- vim.api.nvim_set_hl(0, "@lsp.type.interface.java", { fg = "#f6993f" })
            --
            -- vim.api.nvim_set_hl(0, "Operator", { fg = "#e5e5e5" }) -- Color for module paths in imports
        end
    },
    {
        "xiantang/darcula-dark.nvim",
        config = function()
            -- setup must be called before loading
            require("darcula").setup({
                override = function(c)
                    return {
                        background = "#333333",
                        dark = "#000000"
                    }
                end,
                opt = {
                    integrations = {
                        telescope = false,
                        lualine = true,
                        lsp_semantics_token = true,
                        nvim_cmp = true,
                        dap_nvim = true,
                    },
                },
            })
        end,
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require("lualine").setup({
                options = {
                    theme = config.lualine.theme,
                }
            })
        end
    },
}
