return {
    {
        "nvim-java/nvim-java",
        dependencies = {
            "nvim-java/lua-async-await",
            "nvim-java/nvim-java-refactor",
            "nvim-java/nvim-java-core",
            "nvim-java/nvim-java-test",
            "nvim-java/nvim-java-dap",
            "MunifTanjim/nui.nvim",
            "mfussenegger/nvim-dap",
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
                    "jiangmiao/auto-pairs",
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
                            -- "perlnavigator",
                            "clangd",
                            "jdtls",
                        },
                        handlers = {
                            function(server_name) -- default handler (optional)
                                require("lspconfig")[server_name].setup {
                                    capabilities = capabilities
                                }
                            end,

                            ["lua_ls"] = function()
                                local lspconfig = require("lspconfig")
                                lspconfig.lua_ls.setup {
                                    capabilities = capabilities,
                                    settings = {
                                        Lua = {
                                            diagnostics = {
                                                globals = { "vim", "it", "describe", "before_each", "after_each" },
                                            }
                                        }
                                    }
                                }
                            end,
                            ["perlnavigator"] = function()
                                require("lspconfig").perlnavigator.setup {
                                    cmd = { "perlnavigator" },
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
                                }
                            end,
                            --
                            -- ["perlpls"] = function()
                            --     require("lspconfig").perlpls.setup {
                            --         settings = {
                            --             pls = {
                            --                 inc = { '~/local/lib/perl5/PLS' },                                              -- add list of dirs to @INC
                            --                 -- cwd = { '~/projects' },                                                         -- working directory for PLS
                            --                 perlcritic = { enabled = true, perlcriticrc = '~/.perlcriticrc' },              -- use perlcritic and pass a non-default location for its config
                            --                 syntax = { enabled = true, perl = '/usr/bin/perl', args = { 'arg1', 'arg2' } }, -- enable syntax checking and use a non-default perl binary
                            --                 perltidy = { perltidyrc = '~/.perltidyrc' }                                     -- non-default location for perltidy's config
                            --             }
                            --         }
                            --     }
                            -- end,
                            --
                            -- Add a handler for jdtls (Java LSP)
                            ["jdtls"] = function()
                                local home = os.getenv("HOME")
                                local workspace_dir = home ..
                                    "/workspace/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

                                require("java").setup()
                                require('lspconfig').jdtls.setup({
                                    on_attach = function(client, bufnr)
                                        -- Disable semantic highlighting
                                        client.server_capabilities.semanticTokensProvider = nil
                                    end,
                                    handlers = {
                                        ['language/status'] = function(_, result)
                                            vim.print('***')
                                        end,
                                        ['$/progress'] = function(_, result, ctx)
                                            vim.print('---')
                                        end,
                                    },
                                })
                                -- Add this line for using the wrapped jdtls.setup

                                -- require("lspconfig").jdtls.setup({
                                --     capabilities = capabilities,
                                --     cmd = { "jdtls" },
                                --     root_dir = require('lspconfig.util').root_pattern('.git', 'mvnw', 'gradlew',
                                --         'pom.xml',
                                --         'build.gradle'),
                                --     settings = {
                                --         java = {
                                --             autobuild = {
                                --                 enabled = false,
                                --             },
                                --             format = {
                                --                 enabled = true,
                                --             },
                                --         },
                                --     },
                                --     on_attach = function(client, bufnr)
                                --         -- Enable codeLens for Java
                                --         client.resolved_capabilities.document_code_lens = true
                                --     end,
                                -- })
                            end,
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
            }
        },
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
