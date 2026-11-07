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
-- Localleader is used by VimTeX mappings, e.g. <Space>lll to compile
vim.g.maplocalleader = vim.keycode('<Space>l')

-- Basic clipboard interaction
vim.keymap.set({'n', 'x'}, 'gy', '"+y', {desc = 'Copy to clipboard'})
vim.keymap.set({'n', 'x'}, 'gp', '"+p', {desc = 'Paste clipboard text'})

-- Command shortcuts
vim.keymap.set('n', '<leader>w', '<cmd>write<cr>', {desc = 'Save file'})
vim.keymap.set('n', '<leader>q', '<cmd>quitall<cr>', {desc = 'Exit vim'})

vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {
  desc = "Code action",
})

vim.cmd.colorscheme('elflord')

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
vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format, { desc = 'Format current buffer' })


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

-- vimtex
vim.pack.add({ 'https://github.com/lervag/vimtex' })
-- Compiler is latexmk, which is the default, so nothing to set for it.
if vim.fn.has('mac') == 1 then
  -- VimTeX has built-in Skim support, including forward and inverse search
  -- Inverse search (Cmd+Shift+click in Skim) needs a one-time Skim setting:
  --   Preferences -> Sync -> Preset: Custom
  --   Command:   nvim  (use the full path, e.g. /opt/homebrew/bin/nvim, if Skim can't find it)
  --   Arguments: --headless -c "VimtexInverseSearch %line '%file'"
  vim.g.vimtex_view_method = 'skim'
  -- Keep focus in Neovim after forward search
  vim.g.vimtex_view_skim_activate = 0
  -- Update the PDF in Skim after each successful compile
  vim.g.vimtex_view_skim_sync = 1
else
  vim.g.vimtex_view_general_viewer = 'okular'
  vim.g.vimtex_view_general_options = '--unique file:@pdf\\#src:@line@tex'
end

-- There is no LSP for TeX, so let mini.completion fall back to VimTeX's omnifunc
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'tex',
  callback = function()
    vim.b.minicompletion_config = { fallback_action = '<C-x><C-o>' }
  end,
  desc = 'Use VimTeX omni completion in TeX files',
})

-- List of compatible language servers is here:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
vim.lsp.enable({'panache'})

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


if vim.g.neovide then
	vim.o.guifont = "Noto Sans Mono:h20" -- text below applies for VimScript
end
