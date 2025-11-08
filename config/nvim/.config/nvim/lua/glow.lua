local M = {}

-- Default configuration
local config = {
  position = 'right',  -- 'left', 'right', 'top', 'bottom', 'float'
  width = 80,          -- width for vertical splits (left/right) or float
  height = 20,         -- height for horizontal splits (top/bottom) or float
  auto_open = false,   -- automatically open preview when opening markdown files
  auto_close = true,   -- close preview when source buffer is closed
  border = 'rounded',  -- 'none', 'single', 'double', 'rounded', 'solid', 'shadow'
  float_opts = {       -- options for floating window
    relative = 'editor',
    row = 5,           -- row position (nil for centered)
    col = nil,         -- col position (nil for centered)
  },
  keymap = {
    close = 'q',       -- close both buffers
    toggle = '<leader>mp',
    open = '<leader>mo',
    close_preview = '<leader>mc',
  }
}

-- Store terminal buffer and window info
local preview_win = nil
local source_buf = nil
local source_win = nil

-- Function to check if glow is installed
local function check_glow()
  if vim.fn.executable('glow') == 0 then
    vim.notify('glow is not installed', vim.log.levels.ERROR)
    return false
  end
  return true
end

-- Function to get split command based on position
local function get_split_cmd()
  if config.position == 'left' then
    return 'topleft vsplit'
  elseif config.position == 'right' then
    return 'botright vsplit'
  elseif config.position == 'top' then
    return 'topleft split'
  elseif config.position == 'bottom' then
    return 'botright split'
  elseif config.position == 'float' then
    return nil  -- Handle separately
  else
    return 'vsplit'
  end
end

-- Function to create floating window
local function create_float_win(buf)
  local width = config.width
  local height = config.height

  -- Calculate centered position if not specified
  local row = config.float_opts.row
  local col = config.float_opts.col

  if not row then
    row = math.floor((vim.o.lines - height) / 2)
  end
  if not col then
    col = math.floor((vim.o.columns - width) / 2)
  end

  local win_opts = {
    relative = config.float_opts.relative or 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = config.border,
  }

  return vim.api.nvim_open_win(buf, true, win_opts)
end

-- Function to safely close a window
local function safe_close_window(win)
  if not win or not vim.api.nvim_win_is_valid(win) then
    return
  end

  -- For floating windows, we can always close them
  local win_config = vim.api.nvim_win_get_config(win)
  if win_config.relative ~= '' then
    vim.api.nvim_win_close(win, true)
    return
  end

  -- Check if this is the last window
  local wins = vim.api.nvim_list_wins()
  local valid_wins = 0
  for _, w in ipairs(wins) do
    if vim.api.nvim_win_is_valid(w) and vim.api.nvim_win_get_config(w).relative == '' then
      valid_wins = valid_wins + 1
    end
  end

  if valid_wins > 1 then
    vim.api.nvim_win_close(win, true)
  else
    -- If it's the last window, just quit
    vim.cmd('quit')
  end
end

-- Function to close both buffers
local function close_both()
  -- Get all windows before closing
  local wins_to_close = {}

  -- Collect preview window
  if preview_win and vim.api.nvim_win_is_valid(preview_win) then
    table.insert(wins_to_close, preview_win)
  end

  -- Collect source buffer windows
  if source_buf and vim.api.nvim_buf_is_valid(source_buf) then
    local wins = vim.fn.win_findbuf(source_buf)
    for _, win in ipairs(wins) do
      if vim.api.nvim_win_is_valid(win) and win ~= preview_win then
        table.insert(wins_to_close, win)
      end
    end
  end

  -- Check total window count (excluding floating windows)
  local all_wins = vim.api.nvim_list_wins()
  local valid_win_count = 0
  for _, w in ipairs(all_wins) do
    if vim.api.nvim_win_is_valid(w) and vim.api.nvim_win_get_config(w).relative == '' then
      valid_win_count = valid_win_count + 1
    end
  end

  -- If closing all these windows would leave no windows, just quit vim
  if #wins_to_close >= valid_win_count then
    vim.cmd('quitall')
    return
  end

  -- Close windows safely
  for _, win in ipairs(wins_to_close) do
    safe_close_window(win)
  end

  preview_win = nil
  source_buf = nil
  source_win = nil
end

-- Function to update preview by recreating the terminal
local function update_preview()
  if not preview_win or not vim.api.nvim_win_is_valid(preview_win) then
    return
  end

  local filepath = vim.api.nvim_buf_get_name(source_buf)
  if filepath == '' then
    return
  end

  -- Save current window
  local current_win = vim.api.nvim_get_current_win()

  -- For float windows, we need to recreate them
  local is_float = vim.api.nvim_win_get_config(preview_win).relative ~= ''

  -- Switch to preview window
  vim.api.nvim_set_current_win(preview_win)

  -- Get current buffer and delete it
  local old_buf = vim.api.nvim_get_current_buf()

  -- Create a new terminal buffer
  vim.cmd('terminal glow ' .. vim.fn.shellescape(filepath))

  -- Delete old buffer
  if vim.api.nvim_buf_is_valid(old_buf) then
    vim.api.nvim_buf_delete(old_buf, { force = true })
  end

  -- Set window options (use vim.wo for window options)
  vim.wo[preview_win].number = false
  vim.wo[preview_win].relativenumber = false
  vim.wo[preview_win].signcolumn = 'no'

  -- Apply size based on position (only for non-float)
  if not is_float then
    if config.position == 'left' or config.position == 'right' then
      vim.api.nvim_win_set_width(preview_win, config.width)
    else
      vim.api.nvim_win_set_height(preview_win, config.height)
    end
  end

  -- Set buffer options
  local preview_buf = vim.api.nvim_get_current_buf()
  vim.bo[preview_buf].bufhidden = 'wipe'

  -- Set up keymaps for preview buffer
  local opts = { noremap = true, silent = true, buffer = preview_buf }

  -- Disable insert mode keys
  vim.keymap.set('n', 'i', '<Nop>', opts)
  vim.keymap.set('n', 'a', '<Nop>', opts)
  vim.keymap.set('n', 'I', '<Nop>', opts)
  vim.keymap.set('n', 'A', '<Nop>', opts)

  -- Add close keybinding
  if config.keymap.close then
    vim.keymap.set('n', config.keymap.close, close_both, opts)
  end

  -- Exit insert mode
  vim.cmd('stopinsert')

  -- Return to original window
  if vim.api.nvim_win_is_valid(current_win) then
    vim.api.nvim_set_current_win(current_win)
  end
end

-- Function to open preview in split
function M.open_preview()
  if not check_glow() then return end

  -- Check if current buffer is markdown
  if vim.bo.filetype ~= 'markdown' then
    return
  end

  source_buf = vim.api.nvim_get_current_buf()
  source_win = vim.api.nvim_get_current_win()

  -- If preview already exists, just update it
  if preview_win and vim.api.nvim_win_is_valid(preview_win) then
    update_preview()
    return
  end

  -- Get the filepath
  local filepath = vim.api.nvim_buf_get_name(source_buf)

  -- Don't open if no filepath (empty buffer)
  if filepath == '' then
    return
  end

  -- Create buffer for terminal
  local buf = vim.api.nvim_create_buf(false, true)

  -- Track if we're using float
  local is_float = config.position == 'float'

  -- Handle float window separately
  if is_float then
    preview_win = create_float_win(buf)
  else
    -- Create split with terminal based on position
    local split_cmd = get_split_cmd()
    vim.cmd(split_cmd)
    preview_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(preview_win, buf)

    -- Set window options (use vim.wo for window options)
    vim.wo[preview_win].number = false
    vim.wo[preview_win].relativenumber = false
    vim.wo[preview_win].signcolumn = 'no'

    -- Apply size based on position
    if config.position == 'left' or config.position == 'right' then
      vim.api.nvim_win_set_width(preview_win, config.width)
    else
      vim.api.nvim_win_set_height(preview_win, config.height)
    end
  end

  -- Run glow in terminal
  vim.fn.termopen('glow ' .. vim.fn.shellescape(filepath))

  -- Set buffer options (use vim.bo for buffer options)
  vim.bo[buf].bufhidden = 'wipe'

  -- Set up keymaps for preview buffer
  local opts = { noremap = true, silent = true, buffer = buf }

  -- Disable insert mode keys
  vim.keymap.set('n', 'i', '<Nop>', opts)
  vim.keymap.set('n', 'a', '<Nop>', opts)
  vim.keymap.set('n', 'I', '<Nop>', opts)
  vim.keymap.set('n', 'A', '<Nop>', opts)

  -- Add close keybinding
  if config.keymap.close then
    vim.keymap.set('n', config.keymap.close, close_both, opts)
  end

  -- Also add close keybinding to source buffer
  if config.keymap.close then
    vim.keymap.set('n', config.keymap.close, close_both, { noremap = true, silent = true, buffer = source_buf })
  end

  -- Setup autocmd for auto-update on save
  local group = vim.api.nvim_create_augroup('GlowPreview_' .. source_buf, { clear = true })

  vim.api.nvim_create_autocmd('BufWritePost', {
    group = group,
    buffer = source_buf,
    callback = update_preview
  })

  -- Close preview when source buffer is closed with :q, :bd, or :bw
  vim.api.nvim_create_autocmd({'QuitPre', 'BufDelete', 'BufWipeout'}, {
    group = group,
    buffer = source_buf,
    callback = function()
      if preview_win and vim.api.nvim_win_is_valid(preview_win) then
        safe_close_window(preview_win)
        preview_win = nil
      end
    end
  })

  -- Cleanup when preview window is closed
  vim.api.nvim_create_autocmd('WinClosed', {
    group = group,
    callback = function()
      if not preview_win or not vim.api.nvim_win_is_valid(preview_win) then
        preview_win = nil
        vim.api.nvim_clear_autocmds({ group = group })
      end
    end
  })

  -- Exit terminal mode
  vim.cmd('stopinsert')

  -- Return to source window only if NOT float
  if not is_float and vim.api.nvim_win_is_valid(source_win) then
    vim.api.nvim_set_current_win(source_win)
  end
  -- If float, cursor stays in the floating window for interaction
end

-- Function to close preview only
function M.close_preview()
  safe_close_window(preview_win)
  preview_win = nil
end

-- Function to close both buffers
function M.close_both()
  close_both()
end

-- Function to toggle preview
function M.toggle_preview()
  if preview_win and vim.api.nvim_win_is_valid(preview_win) then
    M.close_preview()
  else
    M.open_preview()
  end
end

-- Setup function for configuration
function M.setup(user_config)
  -- Merge user config with defaults
  config = vim.tbl_deep_extend('force', config, user_config or {})

  -- Set up global keymaps if provided
  if config.keymap.toggle then
    vim.keymap.set('n', config.keymap.toggle, M.toggle_preview,
      { noremap = true, silent = true, desc = 'Toggle Glow Preview' })
  end

  if config.keymap.open then
    vim.keymap.set('n', config.keymap.open, M.open_preview,
      { noremap = true, silent = true, desc = 'Open Glow Preview' })
  end

  if config.keymap.close_preview then
    vim.keymap.set('n', config.keymap.close_preview, M.close_preview,
      { noremap = true, silent = true, desc = 'Close Glow Preview' })
  end

  -- Set up auto-open for markdown files
  if config.auto_open then
    -- Check if glow is installed before setting up autocmds
    if not check_glow() then
      vim.notify('glow-preview: auto_open disabled - glow is not installed', vim.log.levels.WARN)
      return
    end

    local group = vim.api.nvim_create_augroup('GlowAutoOpen', { clear = true })

    -- Use FileType which is more reliable
    vim.api.nvim_create_autocmd('FileType', {
      group = group,
      pattern = 'markdown',
      callback = function()
        -- Delay slightly to ensure everything is loaded
        vim.defer_fn(function()
          M.open_preview()
        end, 100)
      end
    })

    -- Also try on BufWinEnter as backup
    vim.api.nvim_create_autocmd('BufWinEnter', {
      group = group,
      pattern = {'*.md', '*.markdown'},
      callback = function(args)
        vim.defer_fn(function()
          if vim.bo[args.buf].filetype == 'markdown' then
            M.open_preview()
          end
        end, 150)
      end
    })
  end
end

return M


