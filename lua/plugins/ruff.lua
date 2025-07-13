return {
    -- add ruff to lspconfig
    {
        "neovim/nvim-lspconfig",
        ---@class PluginLspOpts
        opts = {
            ---@type lspconfig.options
            servers = {
                -- ruff will be automatically installed with mason and loaded with lspconfig
                ruff = {},
            },
        },
    },
}
