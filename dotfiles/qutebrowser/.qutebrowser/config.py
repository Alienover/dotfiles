import catppuccin

c = c  # noqa # pyright: ignore[reportUndefinedVariable]
config = config  # noqa # pyright: ignore[reportUndefinedVariable]

config.load_autoconfig(False)

# Theme
catppuccin.setup(c, "mocha", True)

c.colors.webpage.darkmode.enabled = True
DARKMODE_BLACKLIST = ["www.youtube.com"]
for site in DARKMODE_BLACKLIST:
    config.set("colors.webpage.darkmode.enabled", False, site)

c.fonts.default_size = "14pt"

c.window.hide_decoration = True

c.hints.border = "none"
c.hints.chars = "asdfghjklzxcvbnm"
c.hints.selectors["video"] = ["video"]

c.scrolling.smooth = True

c.statusbar.show = "in-mode"
c.statusbar.widgets = ["search_match", "text:|", "url", "text:|", "scroll"]

c.tabs.show = "multiple"
c.tabs.padding = {"top": 5, "bottom": 5, "left": 10, "right": 10}

c.content.fullscreen.window = True
c.content.blocking.enabled = True

# Privacy
c.content.canvas_reading = False
c.content.geolocation = False
c.content.webrtc_ip_handling_policy = "default-public-interface-only"

c.url.default_page = "https://www.google.com"
c.url.start_pages = "about:blank"
c.url.searchengines = {
    "DEFAULT": "https://www.google.com/search?q={}",
    "@yt": "https://www.youtube.com/results?search_query={}",
    "@b": "https://search.bilibili.com/all?keyword={}",
}

c.aliases = {
    "q": "tab-close",
    "q!": "close",
    "qa!": "quit",
    "blur-input": "jseval -q document.activeElement.blur()",
}

c.editor.command = [
    "/opt/homebrew/bin/kitty",
    "-e",
    "nvim",
    "{file}",
    "-c",
    "normal {line}G{column0}l",
]


config.source("keymaps.py")
