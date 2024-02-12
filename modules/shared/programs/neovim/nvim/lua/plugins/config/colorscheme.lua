local status_ok, catppuccin = pcall(require, "catppuccin")
if not status_ok then
  return
end

catppuccin.setup {
    color_overrides = {
        all = {
            text = "#ffffff",
        },
        mocha = {
            base = "#1e1e2e",
        },
        frappe = {},
        macchiato = {},
        latte = {},
    }
}

vim.opt.fillchars = {
  horiz = '━',
  horizup = '┻',
  horizdown = '┳',
  vert = '┃',
  vertleft  = '┫',
  vertright = '┣',
  verthoriz = '╋',
}

vim.cmd.colorscheme("catppuccin")
