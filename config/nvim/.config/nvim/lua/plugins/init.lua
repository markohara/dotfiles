-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    { import = "plugins.themes"},
    { import = "plugins.specs" },
  },
  checker = { enabled = true },
})


vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*.md",
  callback = function()
    -- Get the buffer number and content
    local bufnr = vim.api.nvim_get_current_buf()
    
    -- Create a temporary file
    local tmp_file = os.tmpname()
    
    -- Open a vertical split to the right
    vim.cmd('rightbelow vnew')
    local preview_bufnr = vim.api.nvim_get_current_buf()
    
    -- Function to update temp file with current buffer content
    local function update_preview()
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      local content = table.concat(lines, '\n')
      local f = io.open(tmp_file, 'w')
      f:write(content)
      f:close()
    end
    
    -- Initial update
    update_preview()
    
    -- Run entr with glow to watch and update
    local command = string.format("ls %s | entr -src 'glow %s'", tmp_file, tmp_file)
    vim.fn.termopen(command)
    
    -- Create autocmd to update when buffer changes
    vim.api.nvim_create_autocmd({"TextChanged", "TextChangedI"}, {
      buffer = bufnr,
      callback = update_preview
    })
    
    -- Set up scroll binding between buffers
    vim.cmd('setlocal scrollbind')
    vim.cmd('wincmd p') -- Go back to original buffer
    vim.cmd('setlocal scrollbind')
    
    -- Create autocmd to maintain scroll binding when entering either buffer
    vim.api.nvim_create_autocmd("BufEnter", {
      buffer = bufnr,
      callback = function()
        vim.cmd('setlocal scrollbind')
      end
    })
  end
})


-- vim.api.nvim_create_autocmd("BufRead", {
--   pattern = "*.md",
--   callback = function()
--     -- Get the full path of the current buffer
--     local filepath = vim.fn.expand("%:p")
    
--     -- Debug: print the filepath to verify it's correct
--     print("Markdown file path: " .. filepath)
    
--     -- Ensure the file exists and is not empty
--     if vim.fn.filereadable(filepath) == 1 then
--       -- Open a vertical split to the right
--       vim.cmd('rightbelow vnew')
      
--       -- Use termopen with glow and the full filepath
--       local terms = vim.api.nvim_exec2('term glow ' .. filepath, { capture = true })
      
--       -- Optional: set some buffer options for the terminal
--       local term_bufnr = vim.api.nvim_get_current_buf()
--       vim.bo[term_bufnr].buftype = 'nofile'
--       vim.bo[term_bufnr].swapfile = false
      
--       -- Create an autocmd to update glow when the buffer changes
--       vim.api.nvim_create_autocmd({"TextChanged", "TextChangedI"}, {
--         buffer = 0,  -- Current buffer (original markdown buffer)
--         callback = function()
--           local current_filepath = vim.fn.expand("%:p")
          
--           -- Switch to the terminal window and update
--           vim.cmd('wincmd p')  -- Go to terminal window
--           vim.cmd('normal! ggdG')  -- Clear the buffer
--           vim.cmd('term glow ' .. current_filepath)
--           vim.cmd('wincmd p')  -- Go back to original buffer
--         end
--       })
      
--       -- Go back to the original buffer
--       vim.cmd('wincmd p')
--     else
--       print("File is not readable or does not exist")
--     end
--   end
-- })
