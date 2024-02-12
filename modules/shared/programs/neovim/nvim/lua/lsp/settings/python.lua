local status_ok, py_lsp = pcall(require, "py_lsp")
if not status_ok then
  return
end

py_lsp.setup{
  host_python = "/usr/local/bin/python3"
}
