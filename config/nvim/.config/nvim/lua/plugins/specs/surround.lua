-- return {
--   "tpope/vim-surround",
--   event = "VeryLazy",
--   dependencies = {
--     "tpope/vim-repeat",
--   },
-- }

return {
  "nvim-mini/mini.surround",
  event = "VeryLazy",
  config = function()
    require("mini.surround").setup()
  end
}
