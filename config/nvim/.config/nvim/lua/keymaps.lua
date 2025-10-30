-- Remap leader from default . to " "
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Move code reformating as you go
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move lines down (auto-indent)" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move lines up (auto-indent)" })

-- Join maintaining cursor position
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

-- Yank to system clipboard
vim.keymap.set("v", "<leader>y", [["+y]], { desc = "Yank selection to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank to end of line to system clipboard" })
vim.keymap.set("n", "<leader>yy", [["+yy]], { desc = "Yank line to system clipboard" })

-- Shortcut to open file explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open file explorer" })

-- Go
-- if err shortcut
vim.keymap.set(
    "n",
    "<leader>ee",
    "oif err != nil {<CR>}<Esc>Oreturn err<Esc>",
    { desc = "Insert Go error handling block" }
)
