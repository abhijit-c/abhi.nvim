vim.o.number = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.smartcase = true
vim.o.ignorecase = true
vim.o.wrap = true
vim.o.hlsearch = false
vim.o.signcolumn = 'yes'

-- Space as the leader key
vim.g.mapleader = vim.keycode('<Space>')

-- Basic clipboard interaction
vim.keymap.set({'n', 'x'}, 'gy', '"+y', {desc = 'Copy to clipboard'})
vim.keymap.set({'n', 'x'}, 'gp', '"+p', {desc = 'Paste clipboard text'})

-- Command shortcuts
vim.keymap.set('n', '<leader>w', '<cmd>write<cr>', {desc = 'Save file'})
vim.keymap.set('n', '<leader>q', '<cmd>quitall<cr>', {desc = 'Exit vim'})

vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {
  desc = "Code action",
})

vim.cmd.colorscheme('retrobox')

vim.pack.add({
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/nvim-mini/mini.nvim',
})

require('mini.snippets').setup({})
require('mini.completion').setup({})

require('mini.files').setup({})
vim.keymap.set('n', '<leader>e', '<cmd>lua MiniFiles.open()<cr>', {desc = 'File explorer'})

require('mini.pick').setup({})
vim.keymap.set('n', '<leader><space>', '<cmd>Pick buffers<cr>', {desc = 'Search open files'})
vim.keymap.set('n', '<leader>ff', '<cmd>Pick files<cr>', {desc = 'Search all files'})
vim.keymap.set('n', '<leader>fh', '<cmd>Pick help<cr>', {desc = 'Search help tags'})

-- Open files at the same place where we left off
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(args)
    local buf = args.buf

    if vim.bo[buf].buftype ~= "" then
      return
    end

    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local line_count = vim.api.nvim_buf_line_count(buf)

    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- List of compatible language servers is here:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
vim.lsp.enable({'panache', 'texlab'})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "ruff" then
      client.server_capabilities.hoverProvider = false
    end
  end,
  desc = "LSP: Disable hover capability from Ruff",
})
vim.lsp.enable({'ty', 'ruff'})

-- Lean configuration. Hopefully just working ?!
vim.pack.add { "https://github.com/Julian/lean.nvim" }
vim.g.lean_config = { mappings = true }
