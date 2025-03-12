return {
  "zaldih/themery.nvim",
  lazy = false,
  config = function()
    require("themery").setup({
      themes = {{
        name = "Neo Solarized",
        colorscheme = "NeoSolarized",
      },
      {
        name = "Tokyonight - Night",
        colorscheme = "tokyonight-night",
      },
      {
        name = "Xcode Dark High Contrast",
        colorscheme = "xcodedarkhc",
      },
      {
        name = "Catppuccin Mocha",
        colorscheme = "catppuccin-mocha",
      },
      {
        name = "Everforest Hard",
        colorscheme = "everforest",
      }},
    })
  end
}