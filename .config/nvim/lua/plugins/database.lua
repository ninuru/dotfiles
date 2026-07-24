return {
    {
        "kristijanhusak/vim-dadbod-ui",
        dependencies = {
            { "tpope/vim-dadbod", lazy = true, cmd = "DB" },
            {
                "kristijanhusak/vim-dadbod-completion",
                ft = { "sql", "mysql", "plsql" },
                lazy = true,
                config = function()
                    vim.api.nvim_create_autocmd("FileType", {
                        pattern = { "sql", "mysql", "plsql" },
                        callback = function()
                            require("cmp").setup.buffer({
                                sources = {
                                    { name = "vim-dadbod-completion" },
                                    { name = "buffer" },
                                },
                            })
                        end,
                    })
                end,
            },
        },
        cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
        init = function()
            vim.g.db_ui_use_nerd_fonts = 1
            -- don't run the query on :w; execute explicitly with <leader>S
            vim.g.db_ui_execute_on_save = 0

            -- hide the empty pg_toast / pg_toast_temp_* schemas in the drawer
            vim.g.db_ui_hide_schemas = { "^pg_toast" }

            -- closing the query results window should focus the sql editor,
            -- not the DBUI drawer
            vim.api.nvim_create_autocmd("WinClosed", {
                callback = function(ev)
                    local win = tonumber(ev.match)
                    if not win
                        or not vim.api.nvim_win_is_valid(win)
                        or vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "dbout"
                    then
                        return
                    end
                    vim.schedule(function()
                        for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                            local ft = vim.bo[vim.api.nvim_win_get_buf(w)].filetype
                            if ft == "sql" or ft == "mysql" or ft == "plsql" then
                                vim.api.nvim_set_current_win(w)
                                return
                            end
                        end
                    end)
                end,
            })

            -- Alt+Enter runs the visual selection in DBUI query buffers
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "sql", "mysql", "plsql" },
                callback = function(ev)
                    vim.keymap.set("x", "<M-CR>", "<Plug>(DBUI_ExecuteQuery)", { buffer = ev.buf })
                end,
            })
        end,
    },
}
