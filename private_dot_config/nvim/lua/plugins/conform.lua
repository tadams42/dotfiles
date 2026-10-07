return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      -- "*" runs for every filetype, after the filetype's own formatters
      ["*"] = {
        -- in combination with `vim.opt.fixendofline = true`, this ensures that file is
        -- clean and is ending with single `\n`.
        --
        -- One point of confusion is how nvim renders `\n`. It renders it as a beginning
        -- of line, not ending of it. So, file with single ending `\n` looks like it
        -- doesn't have last blank line. In VSCode this file is rendered more
        -- intuitively - there is ending newline and cursor can even be moved into it.
        "trim_whitespace", "trim_newlines"
      },
    },
  },
}
