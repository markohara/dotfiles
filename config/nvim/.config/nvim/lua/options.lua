local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Appearance
opt.termguicolors = true
opt.guicursor = ""
opt.colorcolumn = "80"
opt.scrolloff = 8

-- Indentation
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

-- Editor behavior
opt.wrap = false

-- Search
opt.hlsearch = false
opt.incsearch = true

-- Files
opt.swapfile = false
opt.backup = false

opt.spell = true
opt.spelllang = "en_us"
