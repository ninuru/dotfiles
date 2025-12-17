return {
  "ej-shafran/compile-mode.nvim",
  version = "^5.0.0",
  -- you can just use the latest version:
  -- branch = "latest",
  -- or the most up-to-date updates:
  -- branch = "nightly",
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- if you want to enable coloring of ANSI escape codes in
    -- compilation output, add:
    { "m00qek/baleia.nvim", tag = "v1.3.0" },
  },
  config = function()
    vim.keymap.set('n', '<leader>c', ':belowright Compile<CR>');

    ---@type CompileModeOpts
    vim.g.compile_mode = {
        input_word_completion = true,
        baleia_setup = true,
        default_command = "",
        focus_compilation_buffer = true,
        bang_expansion = true,
    }
  end
}
