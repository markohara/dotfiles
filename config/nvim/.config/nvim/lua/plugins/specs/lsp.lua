return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
        "stevearc/conform.nvim",
    },

    config = function()
        -- Setup Mason and related tools
        require("mason").setup()
        require("fidget").setup({})
        require("conform").setup({
            formatters_by_ft = {}
        })

        -- Setup completion capabilities
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        -- LSP server configurations
        local server_configs = {
          lua_ls = {
                settings = {
                    Lua = {
                        diagnostics = { globals = { 'vim' } },
                        format = {
                            enable = true,
                            -- Put format options here
                            -- NOTE: the value should be STRING!!
                            defaultConfig = {
                                indent_style = "space",
                                indent_size = "2",
                            }
                        },
                    }
                }
            },
            gopls = {},
            rust_analyzer = {},
            tailwindcss = {
              filetypes = {
                "html", "css", "scss", "javascript", "javascriptreact",
                "typescript", "typescriptreact", "vue", "svelte", "heex"
              },
            },
          }

        -- Setup Mason LSP Config with handlers
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "gopls",
                "tailwindcss",
            },
            automatic_installation = true,
            handlers = {
                -- Default handler
                function(server_name)
                    local config = server_configs[server_name] or {}
                    config.capabilities = capabilities
                    require("lspconfig")[server_name].setup(config)
                end,
            }
        })

        -- Completion setup
        cmp.setup({
            preselect = cmp.PreselectMode.None,
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
                ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = "copilot", group_index = 2 },
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
            }, {
                { name = 'buffer' },
            })
        })

        -- Diagnostic configuration
        vim.diagnostic.config({
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })

        -- LSP Keymaps (consolidated from init.lua)
        local augroup = vim.api.nvim_create_augroup('LSPConfig', {})
        vim.api.nvim_create_autocmd('LspAttach', {
            group = augroup,
            callback = function(e)
                local opts = { buffer = e.buf }
                local keymap = vim.keymap.set

                keymap("n", "gd", vim.lsp.buf.definition, opts)
                keymap("n", "K", vim.lsp.buf.hover, opts)
                keymap("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
                keymap("n", "<leader>vd", vim.diagnostic.open_float, opts)
                keymap("n", "<leader>vca", vim.lsp.buf.code_action, opts)
                keymap("n", "<leader>vrr", vim.lsp.buf.references, opts)
                keymap("n", "<leader>vrn", vim.lsp.buf.rename, opts)
                keymap("i", "<C-h>", vim.lsp.buf.signature_help, opts)
                keymap("n", "[d", vim.diagnostic.goto_next, opts)
                keymap("n", "]d", vim.diagnostic.goto_prev, opts)
            end
        })
    end
}

