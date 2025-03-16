return {
    -- Mason for package management
    {
      'williamboman/mason.nvim',
      config = function()
        require('mason').setup()
      end
    },
    
    -- Mason LSP Config
    {
      'williamboman/mason-lspconfig.nvim',
      dependencies = {
        'neovim/nvim-lspconfig',
        'williamboman/mason.nvim'
      },
      config = function()
        require('mason-lspconfig').setup({
          ensure_installed = {
            'lua_ls',      -- Lua Language Server
            'sourcekit'    -- Swift Language Server
          },
          automatic_installation = true
        })
        
        -- LSP Configuration
        local lspconfig = require('lspconfig')
        
        -- Lua LSP Setup
        lspconfig.lua_ls.setup {
          settings = {
            Lua = {
              diagnostics = {
                globals = { 'vim' }
              }
            }
          }
        }
        
        -- Swift LSP Setup (SourceKit)
        lspconfig.sourcekit.setup {
          capabilities = {
            workspace = {
              didChangeWatchedFiles = {
                dynamicRegistration = true,
              },
            },
          },
        }
      end
    },
}
  
