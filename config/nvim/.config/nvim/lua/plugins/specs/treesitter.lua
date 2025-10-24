-- Tree-sitter configuration for Neovim
-- Provides advanced syntax highlighting, indentation, and code parsing
-- Tree-sitter builds Abstract Syntax Trees (AST) for better language understanding
return {
    {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "vimdoc", "javascript", "typescript", "c", "lua", "rust",
                    "jsdoc", "bash", "go", "swift"
                },
                auto_install = true,
                indent = {
                    enable = true
                },

                highlight = {
                    enable = true,
                    disable = function(_, buf)
                        -- Performance optimization: disable for large files
                        -- Tree-sitter can be slow on very large files (>100KB)
                        local max_filesize = 100 * 1024 -- 100 KB limit
                        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                        if ok and stats and stats.size > max_filesize then
                            vim.notify(
                                "File larger than 100KB treesitter disabled for performance",
                                vim.log.levels.WARN,
                                {title = "Treesitter"}
                            )
                            return true
                        end
                    end,

                    -- Keep traditional vim regex highlighting for specific languages
                    -- alongside Tree-sitter (can cause duplicate highlights but sometimes needed)
                    -- Markdown often needs this for proper rendering of inline code, links, etc.
                    additional_vim_regex_highlighting = { "markdown" },
                },
            })
        end
    },

    -- TREE-SITTER CONTEXT PLUGIN
    -- Shows context (function names, class names, etc.) at the top of the screen
    {
        "nvim-treesitter/nvim-treesitter-context",
        after = "nvim-treesitter",
        config = function()
            require'treesitter-context'.setup{
                enable = true,
                multiwindow = false,
                max_lines = 0,
                min_window_height = 0,
                line_numbers = true,
                multiline_threshold = 20,
                trim_scope = 'outer',
                mode = 'cursor',
                separator = nil,
                zindex = 20,
                on_attach = nil,
            }
        end
    }
}

