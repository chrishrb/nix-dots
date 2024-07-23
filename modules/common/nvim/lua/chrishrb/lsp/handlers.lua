local icons = require "chrishrb.config.icons"

local M = {}

local function location_handler(_, result, ctx)
  vim.g.lsp_last_word = vim.fn.expand('<cword>')
  if result == nil or vim.tbl_isempty(result) then
    print(ctx.method, 'No location found')
    return nil
  end
  local util = require('vim.lsp.util')
  if vim.tbl_islist(result) then
    if #result == 1 then
      util.jump_to_location(result[1], 'utf-8', true)
    elseif #result > 1 then
      util.jump_to_location(result[1], 'utf-8', true)
      print("More than one result, fix it in handlers.lua")
    end
  else
    util.jump_to_location(result, 'utf-8', true)
  end
end

M.setup = function()
  local signs = {
    { name = "DiagnosticSignError", text = icons.diagnostics.Error },
    { name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
    { name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
    { name = "DiagnosticSignInfo", text = icons.diagnostics.Information },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local config = {
    -- disable virtual text
    virtual_text = true,
    -- show signs
    signs = {
      active = signs,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(config)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })

  vim.lsp.handlers['textDocument/declaration'] = location_handler
  vim.lsp.handlers['textDocument/definition'] = location_handler
  vim.lsp.handlers['textDocument/typeDefinition'] = location_handler
  vim.lsp.handlers['textDocument/implementation'] = location_handler
  vim.lsp.handlers["textDocument/publishDiagnostics"] = function (_, result, ctx, config)
    if not result.diagnostics then
      -- INFO: workaround for pls.lua, remove afterwards
      local namespace = vim.lsp.diagnostic.get_namespace(ctx.client_id, false)
      local uri = result.uri
      local fname = vim.uri_to_fname(uri)
      local bufnr = vim.fn.bufadd(fname)
      vim.diagnostic.set(namespace, bufnr, {})
      return
    end

    vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, {
      virtual_text = true,
      underline = true,
      signs = true,
      update_in_insert = true
    })
  end
end

local function lsp_highlight_document(client)
  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.document_highlight then
    vim.api.nvim_exec2(
      [[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]] ,
      { output = false }
    )
  end
end

local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true }
  local map = vim.api.nvim_buf_set_keymap

  map(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  map(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  map(bufnr, "n", "gK", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  map(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  map(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
end

M.on_attach = function(client, bufnr)
  if client.name == "tsserver" then
    client.server_capabilities.document_formatting = false
  end
  lsp_keymaps(bufnr)
  lsp_highlight_document(client)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
  return
end

M.capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

return M
