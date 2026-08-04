vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.undofile = true
vim.opt.scrolloff = 5

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.g.mapleader = " "
vim.keymap.set('i', 'jk', '<Esc>', { silent = true })

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0 -- set to 0 to default to tabstop value

-- use system clipboard
vim.opt.clipboard = "unnamedplus"

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Line diagnostics" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics loclist" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>x", function()
  pcall(vim.cmd, "lclose")
  pcall(vim.cmd, "cclose")
end, { desc = "Close diagnostic lists" })

-- Visit the project page for the latest installation instructions
-- https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
    {
        "https://github.com/folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("tokyonight")
        end,
    },
    {
        "https://github.com/junegunn/fzf.vim",
        dependencies = {
            "https://github.com/junegunn/fzf",
        },
        keys = {
            { "<Leader><Leader>", "<Cmd>Files<CR>", desc = "Find files" },
            { "<Leader>,", "<Cmd>Buffers<CR>", desc = "Find buffers" },
            { "<Leader>/", "<Cmd>Rg<CR>", desc = "Search project" },
        },
    },
    {
        "https://github.com/stevearc/oil.nvim",
        config = function()
            require("oil").setup({
                default_file_explorer = true,
                view_options = {
                    show_hidden = true
                }
            })
        end,
        keys = {
            { "-", "<Cmd>Oil<CR>", desc = "Browse files from here" },
        },
    },
   {
        "https://github.com/windwp/nvim-autopairs",
        event = "InsertEnter", -- Only load when you enter Insert mode
        config = function()
            require("nvim-autopairs").setup()
        end,
    },
    {
        "https://github.com/numToStr/Comment.nvim",
        event = "VeryLazy", -- Special lazy.nvim event for things that can load later and are not important for the initial UI
        config = function()
            require("Comment").setup()
        end,
    },
    {
        "https://github.com/tpope/vim-sleuth",
        event = { "BufReadPost", "BufNewFile" }, -- Load after your file content
    },
    {
        "https://github.com/nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            local ts = require("nvim-treesitter")

            ts.setup({})
            ts.install({
                "sql",
                "bash",
                "lua",
                "python",
                "rust",
                "typescript",
                "javascript",
                "vim",
                "vimdoc",
            })

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
                pattern = "*",
                callback = function(event)
                    pcall(vim.treesitter.start, event.buf)
                end,
            })


        end,
    },
    {
        "https://github.com/neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "https://github.com/williamboman/mason.nvim",
            "https://github.com/williamboman/mason-lspconfig.nvim",
            "https://github.com/hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(event)
                    local opts = { buffer = event.buf }
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                    vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

                    vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
                    vim.keymap.set({ "n", "x" }, "<F3>", function()
                        vim.lsp.buf.format({ async = true })
                    end, opts)
                    vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, opts)
                end,
            })

            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "pyright",
                    "rust_analyzer",
                    "ts_ls",
                    "terraformls",
                },
                handlers = {
                    function(server_name)
                        lspconfig[server_name].setup({
                            capabilities = capabilities,
                        })
                    end,
                },
            })
        end,
    },
    {
        "https://github.com/hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "https://github.com/hrsh7th/cmp-nvim-lsp",
            "https://github.com/L3MON4D3/LuaSnip",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                }),
                sources = {
                    { name = "nvim_lsp" },
                },
            })
        end,
    },
    {
        "https://github.com/folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
            { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
            { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = "c", function() require("flash").toggle() end, desc = "Toggle Flash Search" },
        },
    },
    {
        "https://github.com/nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        config = function()
            require("lualine").setup()
        end,
    },
})
