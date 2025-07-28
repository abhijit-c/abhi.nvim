return {
  -- add texlab to lspconfig
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        texlab = {
          settings = {
            bibtexFormatter = "texlab",
            build = {
              args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
              executable = "latexmk",
              forwardSearchAfter = true,
              onSave = true,
            },
            chktex = {
              onEdit = false,
              onOpenAndSave = false,
            },
            diagnosticsDelay = 300,
            formatterLineLength = 80,
            forwardSearch = {
              args = {},
            },
            latexFormatter = "latexindent",
            latexindent = {
              modifyLineBreaks = false,
            },
          },
        },
      },
    },
  },
}
