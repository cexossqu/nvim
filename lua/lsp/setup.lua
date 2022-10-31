local status, mason = pcall(require, "mason")
if not status then
    vim.notify("没有找到 mason")
    return
end

local status, mason_config = pcall(require, "mason-lspconfig")
if not status then
    vim.notify("没有找到 mason-lspconfig")
    return
end

-- :h mason-default-settings
-- ~/.local/share/nvim/mason
mason.setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

-- mason-lspconfig uses the `lspconfig` server names in the APIs it exposes - not `mason.nvim` package names
-- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md
mason_config.setup({
    ensure_installed = {"sumneko_lua", "cssls", "html", "emmet_ls", "jsonls", "tsserver", "volar"}
})

local lspconfig = require("lspconfig")

-- 安装列表
-- { key: 服务器名， value: 配置文件 }
-- key 必须为下列网址列出的 server name，不可以随便写
-- https://github.com/williamboman/nvim-lsp-installer#available-lsps
local servers = {
    sumneko_lua = require("lsp.config.lua"), -- lua/lsp/config/lua.lua
    -- remark_ls = require("lsp.config.markdown"),
    html = require("lsp.config.html"),
    cssls = require("lsp.config.css"),
    emmet_ls = require("lsp.config.emmet"),
    jsonls = require("lsp.config.json"),
    tsserver = require("lsp.config.ts"),
    volar = require("lsp.config.vue"),
}

for name, config in pairs(servers) do
    if config ~= nil and type(config) == "table" then
        -- 自定义初始化配置文件必须实现on_setup 方法
        config.on_setup(lspconfig[name])
    else
        -- 使用默认参数
        lspconfig[name].setup({})
    end
end
