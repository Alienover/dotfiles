local icons = {
  ui = {
    ArrowClosed = "",
    ArrowOpen = "",
    BigCircle = "",
    BigUnfilledCircle = "",
    BookMark = "",
    Bug = "",
    Calendar = "",
    Check = "󰄬",
    ChevronLeft = "<",
    ChevronRight = ">",
    Circle = "",
    Close = "󰅖",
    CloudDownload = "",
    Code = "",
    Comment = "󰅺",
    Dashboard = "",
    EllipsisH = "",
    Email = "󰇮",
    Fire = "",
    Gear = "",
    HalfCircleLeft = "",
    HalfCircleRight = "",
    History = "󰋚",
    Language = "",
    Lightbulb = "󰌵",
    List = "",
    Lock = "",
    Minus = "󰍴",
    NewFile = "",
    Note = "󰎚",
    Package = "",
    Pencil = "󰏫",
    Project = "",
    Search = "",
    SignIn = "",
    SignOut = "",
    Table = "",
    Telescope = "",
    TriangelLeft = "",
    TriangleRight = "",
  },

  kind = {
    Array = "󰅨",
    Boolean = "",
    Class = "",
    Color = "",
    Constant = "",
    Constructor = "",
    Enum = "",
    EnumMember = "",
    Event = "",
    Field = "",
    File = "",
    Folder = "",
    Function = "",
    Interface = "",
    Keyword = "",
    Method = "",
    Module = "",
    Number = "󰉻",
    Operator = "",
    Property = "",
    Reference = "",
    Snippet = "",
    String = "󰅳",
    Struct = "",
    Text = "",
    TypeParameter = "",
    Unit = "",
    Value = "",
    Variable = "",
  },

  diagnostics = {
    Error = "",
    Hint = "",
    Information = "",
    Question = "",
    Warning = "",
  },

  misc = {
    Command = "󰘳",
    Keyboard = "󰌌",
    Robot = "󰚩",
    Squirrel = "",
    Tag = "",
    Watch = "",
  },

  git = {
    Add = "",
    Diff = "",
    Ignore = "",
    Mod = "",
    Remove = "",
    Rename = "",
    Repo = "",
  },

  documents = {
    File = "",
    Files = "",
    Folder = "",
    OpenFolder = "",
  },
}

local mod = {
  ERROR = icons.diagnostics.Error .. " ",
  WARN = icons.diagnostics.Warning .. " ",
  HINT = icons.diagnostics.Hint .. " ",
  INFOR = icons.diagnostics.Information .. " ",

  ---@type table<string, string>
  kind = setmetatable(icons.kind, {
    __index = function()
      return icons.kind.Text
    end,
  }),
}

return vim.tbl_deep_extend("force", icons, mod)
