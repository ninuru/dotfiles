require("config")
require("set")
require("remap")

require("lazy_init")

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local custom_group = augroup('Custom', {})

vim.filetype.add({
    extension = {
        templ = 'templ',
    }
})

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd({ "BufWritePre" }, {
    group = custom_group,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

autocmd('LspAttach', {
    group = custom_group,
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "gD", function() vim.lsp.buf.type_definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("n", "<leader>vi", function() vim.lsp.buf.implementation() end, opts)
        vim.keymap.set("n", "<leader>vo", function() vim.lsp.buf.declaration() end, opts)
        vim.keymap.set("n", "<C-p>", function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("i", "<C-p>", function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)

        vim.keymap.set("n", "<C-M-K>", function()
          local params = vim.lsp.util.make_position_params()
          vim.lsp.buf_request(0, "textDocument/hover", params, function(err, result, ctx, config)
            if err or not result or not result.contents then return end

            -- open a vertical split and use a scratch buffer
            vim.api.nvim_open_win(0, false, {
              split = 'left',
              win = 0
            })


            local buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_win_set_buf(0, buf)

            local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, markdown_lines)
            vim.bo[buf].filetype = "markdown"
          end)
        end, { buffer = 0 })
    end
})

-- TODO: Learn how to use nvim's filetype configurations
autocmd("FileType", {
    group = custom_group,
    pattern = "perl",
    callback = function()
        vim.opt_local.iskeyword:remove(":")
        -- vim.opt_local.iskeyword:remove("_")
    end,
})


-- bg must be either "none" or a hex color like "#000000"
local function apply_bg()
    local ok, cfg = pcall(require, "config")
    local bg = (ok and cfg.background) or "#000000"  -- fallback

    -- main editor
    vim.api.nvim_set_hl(0, "Normal",   { bg = bg })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = bg })

    -- floats (includes many UI popups)
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = bg })
    vim.api.nvim_set_hl(0, "FloatBorder", { bg = bg })

    -- command line / command bar + messages
    -- (some groups exist only on newer nvim; pcall avoids errors)
    pcall(vim.api.nvim_set_hl, 0, "Cmdline",       { bg = bg })
    pcall(vim.api.nvim_set_hl, 0, "CmdlineNormal", { bg = bg })
    pcall(vim.api.nvim_set_hl, 0, "MsgArea",       { bg = bg })
    pcall(vim.api.nvim_set_hl, 0, "MsgSeparator",  { bg = bg })
    vim.api.nvim_set_hl(0, "WildMenu", { bg = bg })

    -- completion menu (popup menu)
    -- PmenuSel/PmenuThumb keep the colorscheme's contrasting colors,
    -- otherwise the selected entry is invisible against the menu bg
    vim.api.nvim_set_hl(0, "Pmenu",      { bg = bg })
    vim.api.nvim_set_hl(0, "PmenuSbar",  { bg = bg })

    -- nvim-tree
    vim.api.nvim_set_hl(0, "NvimTreeNormal",   { bg = bg })
    vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = bg })

    -- line numbers
    vim.api.nvim_set_hl(0, "LineNr",        { bg = bg })
    vim.api.nvim_set_hl(0, "CursorLineNr",  { bg = bg })

    -- newer nvim versions
    pcall(vim.api.nvim_set_hl, 0, "LineNrAbove", { bg = bg })
    pcall(vim.api.nvim_set_hl, 0, "LineNrBelow", { bg = bg })

    -- columns left of line numbers
    vim.api.nvim_set_hl(0, "SignColumn", { bg = bg })
    vim.api.nvim_set_hl(0, "FoldColumn", { bg = bg })

    -- also needed on many setups (cursorline variants)
    pcall(vim.api.nvim_set_hl, 0, "CursorLineSign", { bg = bg })
    pcall(vim.api.nvim_set_hl, 0, "CursorLineFold", { bg = bg })


    -- current line highlight (otherwise you get a mismatched stripe)
    vim.api.nvim_set_hl(0, "CursorLine", { bg = bg })

    -- telescope
    for _, g in ipairs({
        "TelescopeNormal",
        "TelescopeBorder",
        "TelescopePromptNormal",
        "TelescopePromptBorder",
        "TelescopeResultsNormal",
        "TelescopePreviewNormal",
    }) do
        vim.api.nvim_set_hl(0, g, { bg = bg })
    end
end

autocmd('ColorScheme', {
    group    = custom_group,
    callback = apply_bg,
})

apply_bg()
