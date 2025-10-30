return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
    },
    config = function()
      require('telescope').setup {
        pickers = {
          find_files = {
            --theme = "ivy",
            find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' },
          }
        },
        extensions = {
          fzf = {}
        }
      }

      require('telescope').load_extension('fzf')

      local builtin = require('telescope.builtin')
      vim.keymap.set("n", "<leader>fh", builtin.help_tags)
      -- vim.keymap.set("n", "<leader>ff", builtin.git_files)
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
      vim.keymap.set("n", "<leader>fag", function()
        builtin.live_grep({
          additional_args = function()
            return { "--hidden" }
          end,
        })
      end, { desc = "Grep" })
      vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = 'Telescope live grep' })
      vim.keymap.set("n", "<leader>fd", builtin.find_files)
      vim.keymap.set('n', '<C-p>', builtin.git_files, {})
      vim.keymap.set('n', '<leader>km', builtin.keymaps, {})
      vim.keymap.set("n", "<leader>en", function()
        builtin.find_files {
          cwd = vim.fn.stdpath("config")
        }
      end)
      vim.keymap.set("n", "<leader>ep", function()
        builtin.find_files {
          cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
        }
      end)
    end
  },
}
