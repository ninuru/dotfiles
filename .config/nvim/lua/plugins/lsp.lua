return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/nvim-cmp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "j-hui/fidget.nvim",
            "windwp/nvim-autopairs",
            "numToStr/Comment.nvim",
        },

        config = function()
            local cmp = require('cmp')
            local cmp_lsp = require("cmp_nvim_lsp")
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                cmp_lsp.default_capabilities())

            require("fidget").setup({})
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "rust_analyzer",
                    "perlnavigator",
                    "clangd",
                    "postgres_lsp",
                },
            })

            -- mason-lspconfig v2 dropped the `handlers` API. Servers are now
            -- auto-enabled via vim.lsp.enable(); configure them with the native
            -- vim.lsp.config() (Neovim 0.11+).
            vim.lsp.config("*", { capabilities = capabilities })

            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim", "it", "describe", "before_each", "after_each" },
                        }
                    }
                }
            })

            vim.lsp.config("postgres_lsp", {
                -- use the global config (DB connection) and attach to standalone
                -- SQL buffers instead of requiring a per-project jsonc
                cmd = {
                    "postgres-language-server",
                    "lsp-proxy",
                    "--config-path=" .. vim.fn.expand("~/.config/postgres-language-server"),
                },
                workspace_required = false,
            })

            vim.lsp.config("perlnavigator", {
                settings = {
                    perlnavigator = {
                        perlPath = "perl",
                        enableWarnings = true,
                        perltidyProfile = '~/.perltidyrc',
                        perlcriticProfile = '~/.perlcriticrc',
                        perlcriticEnabled = true,
                        perlcriticSeverity = 3,
                        includePaths = {
                            "$workspaceFolder/local/lib/perl5",
                            "$workspaceFolder/catcher/local/lib/perl5",
                            "$workspaceFolder/manager/local/lib/perl5",
                            "/home/schreider/projects/generic-catcher/lib",
                            "/home/schreider/projects/generic-catcher/local/lib/perl5",
                            "/home/schreider/projects/generic-manager/lib",
                            "/home/schreider/projects/generic-manager/local/lib/perl5"
                        },
                    }
                }
            })

            local cmp_select = { behavior = cmp.SelectBehavior.Select }

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<Enter>'] = cmp.mapping.confirm({ select = true }),
                    ['<TAB>'] = cmp.mapping.confirm({ select = true }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' }, -- For luasnip users.
                }, {
                    { name = 'buffer' },
                })
            })

            require("nvim-autopairs").setup({})
            -- insert () after confirming a function completion
            cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())

            vim.diagnostic.config({
                -- update_in_insert = true,
                float = {
                    focusable = false,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            })

            -- Commentary
            require('Comment').setup()
        end
    },
    {
        'nvim-flutter/flutter-tools.nvim',
        lazy = false,
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        config = true,
    }
}
