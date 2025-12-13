return {
  "nvim-telescope/telescope.nvim",

  tag = "0.1.5",

  dependencies = {
    "nvim-lua/plenary.nvim",
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
  },

  config = function()
    require('telescope').setup({
      -- defaults = {
      --   vimgrep_arguments = {
      --     'rg',
      -- '--color=never',
      --     '--no-heading',
      --     '--with-filename',
      --     '--line-number',
      --     '--column',
      --     '--smart-case',
      --     '--hidden',
      --     '--no-ignore',
      --     '--glob=!.git/',
      --   },
      -- },
      -- pickers = {
      --   find_files = {
      --     find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' },
      --   }
      -- },
      -- extensions = {
      --   fzf = {}
      -- }
    })

    -- require('telescope').load_extension('fzf')
    local builtin = require('telescope.builtin')

    vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Find files in project' })
    -- vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = 'Find git tracked files' })

    vim.keymap.set('n', '<C-p>', function()
      local ok = pcall(builtin.git_files, {
        path_display = { "smart" },
      })
      if not ok then
        builtin.find_files({
          path_display = { "smart" },
        })
      end
    end, { desc = 'Find git tracked files or all files' })


    vim.keymap.set('n', '<leader>vh', builtin.help_tags, { desc = 'Search vim help tags' })
    vim.keymap.set('n', '<leader>km', builtin.keymaps, { desc = 'Telescope keymaps' })
    vim.keymap.set('n', '<leader>pws', function()
      local word = vim.fn.expand("<cword>")
      builtin.grep_string({ search = word, cwd = vim.fn.getcwd() })
    end, { desc = 'Search word under cursor' })

    vim.keymap.set('n', '<leader>pWs', function()
      local word = vim.fn.expand("<cWORD>")
      builtin.grep_string({ search = word })
    end, { desc = 'Search WORD under cursor' })

    vim.keymap.set('v', '<leader>pws', function()
      local start_pos = vim.fn.getpos('v')
      local end_pos = vim.fn.getpos('.')
      local mode = vim.fn.mode()

      local selection = vim.fn.getregion(start_pos, end_pos, { type = mode })[1]

      builtin.grep_string({
        search = selection,
      })
    end, { desc = 'Search for selection' })

    vim.keymap.set('n', '<leader>ps', function()
      builtin.grep_string({ search = vim.fn.input("Grep > ") })
    end, { desc = 'Search with input prompt' })

    -- specific directory search
    vim.keymap.set("n", "<leader>en", function()
      builtin.find_files {
        cwd = vim.fn.stdpath("config")
      }
    end, { desc = 'Search config files' })
  
    vim.keymap.set('n', '<leader>ss', function()
      builtin.spell_suggest({
        initial_mode = "normal"
      })
    end, { desc = 'Spelling suggestions' })

  end
}

