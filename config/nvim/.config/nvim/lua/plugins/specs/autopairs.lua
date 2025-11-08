-- return {
--   'windwp/nvim-autopairs',
--   event = "InsertEnter",
--   config = function ()
--     require('nvim-autopairs').setup({})
--
--     local npairs = require('nvim-autopairs')
--     npairs.clear_rules()
--
--     local Rule = require('nvim-autopairs.rule')
--     npairs.add_rule(Rule("{", "}"))
--     -- npairs.add_rule(Rule("\"", "\""))
--   end
-- }
return {
  "cohama/lexima.vim",
  event = "InsertEnter",
  config = function()
  end,
}

