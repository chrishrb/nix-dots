// map jj to escape in insert and visual mode
glide.keymaps.set(["insert", "visual", "op-pending"], "jj", "mode_change normal");
glide.keymaps.set("normal", "<C-o>", "back");
glide.keymaps.set("normal", "<C-i>", "forward");

// simple tab navigation
glide.keymaps.set("normal", "L", "tab_next");
glide.keymaps.set("normal", "H", "tab_prev");

glide.keymaps.set(
  "command",
  "<c-j>",
  "commandline_focus_next",
);
glide.keymaps.set(
  "command",
  "<c-k>",
  "commandline_focus_back",
);

// bd to close tab
glide.excmds.create({ name: "bd", description: "close tab"}, () => {
  glide.excmds.execute("tab_close")
})

