// Config docs: https://glide-browser.app/config
// API docs: https://glide-browser.app/api
// Default config files: https://github.com/glide-browser/glide/tree/main/src/glide/browser/base/content/plugins
// Default keymappings: https://github.com/glide-browser/glide/blob/main/src/glide/browser/base/content/plugins/keymaps.mts
// Creator's dotfiles: https://github.com/RobertCraigie/dotfiles/tree/main/glide
// Firefox Javascript APIS (use browser.*): https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/Browser_support_for_JavaScript_APIs
// Most code of this file: https://github.com/NonlinearFruit/dotfiles

// TODO:
const path = glide.env.get("PATH")
glide.env.set("PATH", `${path}:/etc/profiles/per-user/christophherb/bin`)

glide.prefs.set("ui.systemUsesDarkTheme", true);
glide.prefs.set("browser.toolbars.bookmarks.visibility", "always")

// https://addons.mozilla.org
glide.addons.install(
  "https://addons.mozilla.org/firefox/downloads/file/4644172/adblock_plus-4.32.2.1.xpi",
);
glide.addons.install(
  "https://addons.mozilla.org/firefox/downloads/file/4654028/1password_x_password_manager-8.11.27.2.xpi",
);
glide.addons.install(
  "https://addons.mozilla.org/firefox/downloads/file/4637154/istilldontcareaboutcookies-1.1.9.xpi"
);
glide.addons.install(
  "https://addons.mozilla.org/firefox/downloads/file/4631982/medium_parser-1.6.5.xpi"
);

glide.autocmds.create("ModeChanged", "*", ({ new_mode }) => {
  const mode_colors: Record<keyof GlideModes, string> = {
    "command": "#689F38", // Green
    "hint": "#00796B", // Teal
    "ignore": "#FF5252", // Red
    "insert": "#FBC02D", // Yellow
    "normal": "#9E9E9E", // Gray
    "op-pending": "#FF8F00", // Orange
    "visual": "#7B1FA2", // Purple
  }
  browser.theme.update({ colors: { frame: mode_colors[new_mode] } });
});

// Tabs
let previousTabId: number | undefined;
browser.tabs.onActivated.addListener((activeInfo) => {
  previousTabId = activeInfo.previousTabId;
});
glide.excmds.create({ name: "b#", description: "Switches to previously active tab" }, async () => {
  if (previousTabId) {
    await browser.tabs.update(previousTabId, { active: true })
  }
});
glide.excmds.create({ name: "bd", description: "Deletes current tab"}, () => {
  glide.excmds.execute("tab_close")
})
glide.excmds.create({ name: "<leader>h", description: "No highlight" }, async () => {
  await browser.find.removeHighlighting()
});

// Search
glide.keymaps.set("normal", "/", "keys <C-f>");
glide.keymaps.set("normal", "<leader>/b", "commandline_show tab ", { description: "Search[/] open tabs ([b]uffers)" });

// map jj to escape in insert and visual mode
// glide.keymaps.set(["insert", "visual", "op-pending"], "jj", "mode_change normal");
glide.keymaps.set(["normal", "insert"], "<C-,>", "blur", { description: "Go to normal mode without focus on a specific element" })

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

glide.excmds.create({ name: "tab_edit", description: "Edit tabs in a text editor" }, async () => {
	const tabs = await browser.tabs.query({ pinned: false });

	const tab_lines = tabs.map((tab) => {
		const title = tab.title?.replace(/\n/g, " ") || "No Title";
		const url = tab.url || "about:blank";
		return `${tab.id}: ${title} (${url})`;
	});

	const mktempcmd = await glide.process.execute("mktemp", ["-t", "glide_tab_edit.XXXXXX"]);

	let stdout = "";
	for await (const chunk of mktempcmd.stdout) {
		stdout += chunk;
	}
	const temp_filepath = stdout.trim();

	tab_lines.unshift("// Delete the corresponding lines to close the tabs");
	tab_lines.unshift("// vim: ft=qute-tab-edit");
	await glide.fs.write(temp_filepath, tab_lines.join("\n"));

	console.log("Temp file created at:", temp_filepath);

	const editcmd = await glide.process.execute("alacritty", [
    "-e", 
    "vim",
    temp_filepath,
    
  ], { env: { 
    }});

	const cp = await editcmd.wait();
	if (cp.exit_code !== 0) {
		throw new Error(`Editor command failed with exit code ${cp.exit_code}`);
	}
	console.log("Edit complete");

	// read the edited file
	const edited_content = await glide.fs.read(temp_filepath, "utf8");
	const edited_lines = edited_content
		.split("\n")
		.filter((line) => line.trim().length > 0)
		.filter((line) => !line.startsWith("//"));

	const tabs_to_keep = edited_lines.map((line) => {
		const tab_id = line.split(":")[0];
		return Number(tab_id);
	});

	const tab_ids_to_close = tabs
		.filter((tab) => tab.id && !tabs_to_keep.includes(tab.id))
		.map((tab) => tab.id)
		.filter((id): id is number => id !== undefined);
	await browser.tabs.remove(tab_ids_to_close);
});

glide.keymaps.set("normal", "yc", () =>
  glide.hints.show({
    selector: "pre,code",
    async action(target) {
      console.log(target)
      const text = (await target.content.execute((target) => target.textContent)).trim()
      console.log(text)
      if (text) {
        await navigator.clipboard.writeText(text);
      }
    }
  }),
  { description: "[y]ank [c]ode -> Shows hints on all preformated text and places the selected codeblock in clipboard" }
)

glide.excmds.create({ name: "tab_only", description: "[tab] [o]nly -> deletes all non-active non-pinned tabs"}, async () => {
  const tabs_to_close = await browser.tabs.query({active: false, pinned: false})
  // @ts-ignore: next-line
  browser.tabs.remove(tabs_to_close.map(t => t.id));
})

glide.autocmds.create("UrlEnter", { hostname: "github.com" }, ({ tab_id }) => {
  glide.buf.keymaps.set("normal", "<leader>d", async () => {
    const [owner] = glide.ctx.url.pathname.split("/").slice(1, 3);
    let directory = "home";
    if (owner === "gipedo") {
      directory = "work";
    }
    await browser.notifications.create({ type: "basic", title: "glide config", message: "Download started..." })
    const clone_url = glide.ctx.url + ".git"
    const git_path = glide.path.join(glide.path.home_dir, "dev", directory)
    await glide.process.execute("git", ["-C", git_path, "clone", clone_url])
    await browser.notifications.create({ type: "basic", title: "glide config", message: "Repo is cloned!" })
  }, { description: "clone ([d]ownload) git repo" })

  glide.buf.keymaps.set("normal", "gx", async () => {
    const [owner, repo] = glide.ctx.url.pathname.split("/").slice(1, 3);
    if (!owner || !repo) throw new Error("current URL is not a github repo");
    let directory = "home";
    if (owner === "gipedo") {
      directory = "work";
    }

    const repo_path = glide.path.join(glide.path.home_dir, "dev", directory, repo);
    if (!(await glide.fs.exists(repo_path))) {
      await browser.notifications.create({ type: "basic", title: "glide config", message: "Repo path does not exist. Download first with <leader>d!" })
      return;
    }

    await glide.process.execute("tmux", ["new-window", "-c", repo_path]);
    await browser.notifications.create({ type: "basic", title: "glide config", message: "Tmux tab created" })
  }, { description: "open repo in tmux" });
});

glide.search_engines.add({
  name: "Google",
  keyword: "g",
  search_url: "https://google.com/search?q={searchTerms}",
  is_default: true
})

glide.search_engines.add({
  name: "GitHub",
  keyword: "gh",
  search_url: "https://github.com/search?q={searchTerms}",
})
