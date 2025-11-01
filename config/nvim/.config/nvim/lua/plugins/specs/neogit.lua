return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim", -- optional
  },
  config = function()
    require('neogit').setup({
      kind = "floating"
    })
    vim.keymap.set("n", "<leader>gs", vim.cmd.Neogit)
  end
}
