-- Folds a file's import prelude into a single fold and closes it on open.
--
-- LSP: rust-analyzer, vtsls and others label their import block fold with kind
-- "imports", so for buffers using LazyVim's LSP folds `vim.lsp.foldclose()` is enough.
--
-- Python: neither pyright nor ruff provide folding ranges. Treesitter's own Python folds group consecutive imports, but a comment or
-- `from __future__ import ...` between them splits the group into several folds. This
-- wraps LazyVim's treesitter foldexpr: lines of the prelude become one level-1 fold
-- (multi-line imports nest at level 2), and everything else is left to treesitter.
--
-- Prelude: the run of top-level import statements, comments between them, and
-- `if TYPE_CHECKING:` blocks, starting at the first import.

local M = {}

---@type table<integer, {tick: integer, first: integer?, last: integer?, nested: table<integer, string>}>
local cache = {}

local function is_type_checking_block(node, buf)
  if node:type() ~= "if_statement" then
    return false
  end
  local cond = node:field("condition")[1]
  local text = cond and vim.treesitter.get_node_text(cond, buf)
  return text == "TYPE_CHECKING" or text == "typing.TYPE_CHECKING"
end

local function is_import(node, buf)
  local t = node:type()
  return t == "import_statement"
    or t == "import_from_statement"
    or t == "future_import_statement"
    or is_type_checking_block(node, buf)
end

-- 1-based first/last line of the prelude, and the fold levels of its multi-line statements
local function prelude(buf)
  local tick = vim.api.nvim_buf_get_changedtick(buf)
  local cached = cache[buf]
  if cached and cached.tick == tick then
    return cached
  end

  local result = { tick = tick, nested = {} }
  cache[buf] = result

  local parser = vim.treesitter.get_parser(buf, "python", { error = false })
  if not parser then
    return result
  end
  local root = parser:parse()[1]:root()

  local nodes = {}
  for node in root:iter_children() do
    if is_import(node, buf) then
      table.insert(nodes, node)
    elseif #nodes > 0 and node:type() ~= "comment" then
      break
    end
  end
  -- drop comments trailing the last import
  while #nodes > 0 and not is_import(nodes[#nodes], buf) do
    table.remove(nodes)
  end
  if #nodes == 0 then
    return result
  end

  result.first = nodes[1]:start() + 1
  result.last = nodes[#nodes]:end_() + 1
  for _, node in ipairs(nodes) do
    local s, e = node:start() + 1, node:end_() + 1
    if e > s and s > result.first then
      result.nested[s] = ">2"
      for l = s + 1, e do
        result.nested[l] = "2"
      end
    end
  end
  if result.last == result.first then
    result.first, result.last = nil, nil
  end
  return result
end

function M.foldexpr()
  local lnum = vim.v.lnum
  local p = prelude(vim.api.nvim_get_current_buf())
  if p.first and lnum >= p.first and lnum <= p.last then
    return lnum == p.first and ">1" or p.nested[lnum] or "1"
  end
  return LazyVim.treesitter.foldexpr()
end

function M.setup()
  local group = vim.api.nvim_create_augroup("prelude_fold", { clear = true })

  vim.api.nvim_create_autocmd("LspNotify", {
    group = group,
    callback = function(ev)
      if ev.data.method ~= "textDocument/didOpen" or vim.b[ev.buf].prelude_folded then
        return
      end
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      local win = vim.fn.bufwinid(ev.buf)
      if not (client and client:supports_method("textDocument/foldingRange") and win ~= -1) then
        return
      end
      vim.b[ev.buf].prelude_folded = true
      local function win_shows_buf()
        return vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == ev.buf
      end
      -- LazyVim switches the window to LSP folds on the next tick. foldclose() is a no-op
      -- until vim.lsp.foldexpr() has been evaluated once, which in turn sets up the
      -- buffer's folding state on the tick after that.
      vim.schedule(function()
        if not win_shows_buf() or not vim.wo[win].foldexpr:find("vim.lsp.foldexpr", 1, true) then
          return
        end
        vim.api.nvim_win_call(win, function()
          vim.fn.foldlevel(1)
        end)
        vim.schedule(function()
          if win_shows_buf() then
            vim.lsp.foldclose("imports", win)
          end
        end)
      end)
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "python",
    callback = function(ev)
      -- like :setlocal; plain vim.wo would leak into other buffers opened in this window
      vim.wo[0][0].foldmethod = "expr"
      vim.wo[0][0].foldexpr = "v:lua.require'config.prelude_fold'.foldexpr()"

      if vim.b[ev.buf].prelude_folded then
        return
      end
      vim.b[ev.buf].prelude_folded = true
      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(ev.buf) or vim.api.nvim_get_current_buf() ~= ev.buf then
          return
        end
        local p = prelude(ev.buf)
        if p.first then
          vim.cmd(p.first .. "foldclose!")
        end
      end)
    end,
  })

  vim.api.nvim_create_autocmd("BufWipeout", {
    group = group,
    callback = function(ev)
      cache[ev.buf] = nil
    end,
  })
end

return M
