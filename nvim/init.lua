vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.number = true
-- y·p가 macOS 클립보드를 쓴다(pbcopy/pbpaste).
vim.opt.clipboard = 'unnamedplus'

-- 색 테마: GitHub 웹의 밝은 코드 색. 버전은 nvim-pack-lock.json에 고정한다.
vim.pack.add({ 'https://github.com/projekt0n/github-nvim-theme' })
vim.cmd.colorscheme('github_light_default')

-- 입력 모드를 나가면 영문 자판으로 바꾼다. 한글 상태로 노멀 모드에 오면 단축키가 안 먹는다.
if vim.fn.executable('macism') == 1 then
  vim.api.nvim_create_autocmd('InsertLeave', {
    callback = function()
      vim.system({ 'macism', 'com.apple.keylayout.ABC' })
    end,
  })
end

-- Python 언어 서버. 값은 nvim-lspconfig의 lsp/pyrefly.lua와 같다.
if vim.fn.executable('pyrefly') == 1 then
  vim.lsp.config('pyrefly', {
    cmd = { 'pyrefly', 'lsp' },
    filetypes = { 'python' },
    root_markers = { 'pyrefly.toml', 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', '.git' },
  })
  vim.lsp.enable('pyrefly')
end
