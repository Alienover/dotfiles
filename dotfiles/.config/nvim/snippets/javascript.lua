local ls = require("luasnip")

local fmt = require("luasnip.extras.fmt").fmt

local rep = require("luasnip.extras").rep

local s, i, f = ls.snippet, ls.insert_node, ls.function_node

return {
  s(
    "type-actions",
    fmt(
      table.concat({
        "export type {}Request = {{",
        "  type: '{}_REQUEST',",
        "  payload: void,",
        "  meta: ActionMeta",
        "}}",
        "",
        "export type {}Success = {{",
        "  type: '{}_SUCCESS',",
        "  payload: {},",
        "  meta: ActionMeta",
        "}}",
        "",
        "export type {}Failure = {{",
        "  type: '{}_FAILURE',",
        "  payload: {{ message: string }},",
        "  meta: ActionMeta",
        "}}",
      }, "\n"),
      { i(1), i(2), rep(1), rep(2), i(0), rep(1), rep(2) }
    )
  ),

  s(
    "actions",
    fmt(
      table.concat({
        "export const {}Actions: {{",
        "  request: ActionCreator<{}Request>,",
        "  success: ActionCreator<{}Success>,",
        "  failure: ActionCreator<{}Failure>,",
        "}} = {{",
        "  request: createAction('{}_REQUEST'),",
        "  success: createAction('{}_SUCCESS'),",
        "  failure: createAction('{}_FAILURE'),",
        "}}",
      }, "\n"),
      { i(1), i(2), rep(2), rep(2), i(3), rep(3), rep(3) }
    )
  ),

  s(
    "action",
    fmt(
      table.concat({
        "export const {}: ActionCreator<{}> = createAction('{}')",
      }, "\n"),
      { i(1), i(2), i(3) }
    )
  ),

  s("lodash", fmt([[import {} from "lodash/{}"]], { rep(1), i(1) })),

  s("import", fmt([[import {} from "{}"]], { i(0), i(1) })),
}
