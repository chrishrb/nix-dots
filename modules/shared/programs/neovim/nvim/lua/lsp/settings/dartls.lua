return {
  lsp = {
    color = {
      enabled = true,
    },
    on_attach = require("lsp.handlers").on_attach,
    capabilities = require("lsp.handlers").capabilities,
    snippets = {
      enableSnippets = true,
    }
  }
}
