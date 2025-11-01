return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    local neogit = require('neogit')

    neogit.setup({
      kind = "floating"
    })

    -- Main Neogit status keybinding
    vim.keymap.set("n", "<leader>gs", vim.cmd.Neogit, { desc = "Open Neogit status" })

    local Mark_Neogit = vim.api.nvim_create_augroup("Mark_Neogit", {})

    vim.api.nvim_create_autocmd("FileType", {
      group = Mark_Neogit,
      pattern = "Neogit*",
      callback = function()
        if not vim.bo.ft:match("^Neogit") then
          return
        end

        local bufnr = vim.api.nvim_get_current_buf()
        local opts = { buffer = bufnr, remap = false, desc = "" }

        -- Push to remote
        vim.keymap.set("n", "<leader>p", function()
          vim.cmd("Neogit push")
        end, opts,  { desc = "Git push" })

        -- Pull with rebase
        vim.keymap.set("n", "<leader>P", function()
          vim.cmd("Neogit pull")
        end, opts,  { desc = "Git pull" })
      end,
    })

  end
}

