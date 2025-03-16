return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { 
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
    config = function()
        local harpoon = require("harpoon")
        harpoon:setup({
          settings = {
            save_on_toggle = true,
            sync_on_ui_close = true,
          }
        })

        vim.keymap.set(
           "n",
            "<leader>a",
            function()
                local fidget = require("fidget")
                local current_file = vim.fn.expand("%:t")

                harpoon:list():add()
                fidget.notify("Added " .. current_file .. " to Harpoon")
            end,
            {desc = "Harpoon: Add file with notification"}
        )

        vim.keymap.set("n", "<BS>H", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
            { desc = "Harpoon: Toggle quick menu" })

        vim.keymap.set("n", "<BS>j", function() harpoon:list():select(1) end,
            { desc = "Harpoon: File 1" })
        vim.keymap.set("n", "<BS>k", function() harpoon:list():select(2) end,
            { desc = "Harpoon: File 2" })
        vim.keymap.set("n", "<BS>l", function() harpoon:list():select(3) end,
            { desc = "Harpoon: File 3" })
        vim.keymap.set("n", "<BS>;", function() harpoon:list():select(4) end,
            { desc = "Harpoon: File 4" })

        vim.keymap.set("n", "<BS>p", function() harpoon:list():prev() end,
            { desc = "Harpoon: Previous file" })
        vim.keymap.set("n", "<BS>n", function() harpoon:list():next() end,
            { desc = "Harpoon: Next file" })

        local function toggle_telescope(harpoon_files)
            local file_paths = {}
            for _, item in ipairs(harpoon_files.items) do
                table.insert(file_paths, item.value)
            end

            require("telescope.pickers").new({}, {
                prompt_title = "Harpoon",
                finder = require("telescope.finders").new_table({
                    results = file_paths,
                }),
                previewer = require("telescope.config").values.file_previewer({}),
                sorter = require("telescope.config").values.generic_sorter({}),
            }):find()
        end

        vim.keymap.set("n", "<BS>h", function() toggle_telescope(harpoon:list()) end,
            { desc = "Harpoon: Telescope" })
    end
}

