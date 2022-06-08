local M = {}

M.custom_plugins = {
  lspsaga = "~/Documents/myself/lspsaga.nvim",
  lspinstaller = "~/Documents/myself/nvim-lsp-installer",
  gps = os.getenv("HOME") .. "/src/nvim-gps",
}

M.files = {
  vim = os.getenv("HOME") .. "/.vimrc",
  -- NeoVim initialization file
  nvim = os.getenv("XDG_CONFIG_HOME") .. "/nvim/init.vim",
  -- Folder saved snippets
  snippets = os.getenv("XDG_CONFIG_HOME") .. "/nvim/snippets",
  -- Tmux config
  tmux = os.getenv("HOME") .. "/.tmux.conf",
  -- Kitty config
  kitty = os.getenv("XDG_CONFIG_HOME") .. "/kitty/kitty.conf",
  -- ZSH config
  zsh = os.getenv("XDG_CONFIG_HOME") .. "/zsh/.zshrc",
  -- Yabai config
  yabai = os.getenv("XDG_CONFIG_HOME") .. "/yabai/yabairc",
  -- SKHD config
  skhd = os.getenv("XDG_CONFIG_HOME") .. "/skhd/skhdrc",
  -- Work directories
  polaris = os.getenv("HOME") .. "/Documents/work/agent8/Polaris",
  rigel = os.getenv("HOME") .. "/Documents/work/agent8/Rigel",
}

M.colors = {
  FG = os.getenv("GUI_FOREGROUND"),
  BG = os.getenv("GUI_BACKGROUND"),
  RED = os.getenv("GUI_RED"),
  DARK_RED = os.getenv("GUI_DARK_RED"),
  GREEN = os.getenv("GUI_GREEN"),
  PRIMARY = os.getenv("GUI_BLUE"),
  VISUAL_GREY = os.getenv("GUI_VISUAL_GREY"),
  DARK_YELLOW = os.getenv("GUI_DARK_YELLOW"),
  COMMENT_GREY = os.getenv("GUI_COMMENT_GREY"),
  SPECIAL_GREY = os.getenv("GUI_SPECIAL_GREY"),
}

M.icons = {
  ERROR = "✖ ",
  WARN = " ",
  HINT = " ",
  INFOR = " ",
  kind = {
    Text = "",
    Method = "",
    Function = "",
    Constructor = "",
    Field = "",
    Variable = "",
    Class = "",
    Interface = "",
    Module = "",
    Property = "",
    Unit = "",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = "",
  },
  type = {
    Array = "",
    Number = "",
    String = "",
    Boolean = "蘒",
    Object = "",
  },
  documents = {
    File = "",
    Files = "",
    Folder = "",
    OpenFolder = "",
  },
  git = {
    Add = "",
    Mod = "",
    Remove = "",
    Ignore = "",
    Rename = "",
    Diff = "",
    Repo = "",
  },
  ui = {
    ArrowClosed = "",
    ArrowOpen = "",
    Lock = "",
    Circle = "",
    BigCircle = "",
    BigUnfilledCircle = "",
    Close = "",
    NewFile = "",
    Search = "",
    Lightbulb = "",
    Project = "",
    Dashboard = "",
    History = "",
    Comment = "",
    Bug = "",
    Code = "",
    Telescope = "",
    Gear = "",
    Package = "",
    List = "",
    SignIn = "",
    SignOut = "",
    Check = "",
    Fire = "",
    Note = "",
    BookMark = "",
    Pencil = "",
    ChevronLeft = "<",
    ChevronRight = ">",
    Table = "",
    Calendar = "",
    CloudDownload = "",
    Language = "",
    TriangleRight = "",
    TriangelLeft = "",
    HalfCircleLeft = "",
    HalfCircleRight = "",
    Email = "",
  },
  diagnostics = {
    Error = "",
    Warning = "",
    Information = "",
    Question = "",
    Hint = "",
  },
  misc = {
    Robot = "ﮧ",
    Squirrel = "",
    Tag = "",
    Watch = "",
  },
}

return M
