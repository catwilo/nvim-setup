-- nvim-setup — init.lua (Lazy + vim.lsp native, 0.11+ API)
-- managed by nvim-setup/setup.sh — do not edit deployed copy directly

-- ── options ──────────────────────────────────────────────────────────────────
vim.opt.cursorline  = true
vim.opt.tabstop     = 2
vim.opt.shiftwidth  = 2
vim.opt.expandtab   = true
vim.opt.foldmethod  = 'indent'
vim.opt.mouse       = 'v'
vim.o.cmdheight     = 0
vim.filetype.add({ extension = { njk = 'html' } })

-- ── colors ───────────────────────────────────────────────────────────────────
vim.cmd [[
  colorscheme default
  highlight Normal         guibg=NONE  ctermbg=NONE
  highlight NonText        guibg=NONE  ctermbg=NONE
  highlight SignColumn      guibg=NONE  ctermbg=NONE
  highlight LineNr         guibg=NONE  ctermbg=NONE
  highlight CursorLineNr   guibg=NONE  ctermbg=NONE
  highlight Normal         ctermfg=White   guifg=White
  highlight Function       guifg=#99ccff   ctermfg=LightBlue
  highlight String         guifg=#ffffcc   ctermfg=Yellow
  highlight Comment        guifg=#008080   ctermfg=Magenta
  highlight Keyword        guifg=#00FF00
  highlight Type           guifg=#099F18
  highlight Pmenu          guibg=#282828   guifg=#FFFFFF
  highlight PmenuSel       guibg=#5e81ac   guifg=#FFFFFF
  highlight PmenuSbar      guibg=#3b3b3b
  highlight PmenuThumb     guibg=#d8d8d8
]]

-- ── clipboard (clipso) ───────────────────────────────────────────────────────
local clipso = vim.fn.expand('$HOME/unix-toolkit-tools/clipso/clipso.sh')
if vim.fn.executable(clipso) == 1 then
  vim.g.clipboard = {
    name  = 'clipso',
    copy  = { ['+'] = { clipso }, ['*'] = { clipso } },
    paste = { ['+'] = { 'xclip', '-o', '-selection', 'clipboard' },
              ['*'] = { 'xclip', '-o', '-selection', 'primary'   } },
    cache_enabled = 0,
  }
end

-- ── Lazy bootstrap ───────────────────────────────────────────────────────────
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({ 'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  { 'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts  = { auto_install = false, highlight = { enable = true } },
  },
}, { change_detection = { notify = false } })

-- ── LSP (vim.lsp native 0.11+, servers from servers.lua) ────────────────────
local ok, servers = pcall(dofile, vim.fn.expand('$HOME/unix-toolkit-tools/nvim-setup/lib/servers.lua'))
if ok then
  for name, cfg in pairs(servers) do
    vim.lsp.config(name, cfg)
    vim.lsp.enable(name)
  end
end

-- ── keymaps ──────────────────────────────────────────────────────────────────
vim.keymap.set('n', 'gd',  vim.lsp.buf.definition,    { desc = 'LSP: go to definition' })
vim.keymap.set('n', 'K',   vim.lsp.buf.hover,          { desc = 'LSP: hover' })
vim.keymap.set('n', 'grn', vim.lsp.buf.rename,         { desc = 'LSP: rename' })
vim.keymap.set('n', 'gra', vim.lsp.buf.code_action,    { desc = 'LSP: code action' })
vim.keymap.set('n', 'grr', vim.lsp.buf.references,     { desc = 'LSP: references' })
