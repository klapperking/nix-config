{ pkgs, ... }:
{
  # Neovim + LazyVim starter + Tokyo Night preset.
  #
  # LazyVim bootstraps itself from lazy.nvim at first launch, then manages plugins.
  # This means plugin state floats outside Nix (LazyVim self-updates). For a
  # fully declarative pin, see Phase 2b TODO below.
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;

    plugins = with pkgs.vimPlugins; [
      lazy-nvim
    ];

    initLua = ''
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.termguicolors = true
      vim.opt.expandtab = true
      vim.opt.shiftwidth = 2
      vim.opt.tabstop = 2
      vim.opt.signcolumn = "yes"
      vim.opt.updatetime = 250

      require("config.lazy")
    '';

    # Note: `initLua` replaced the deprecated `extraLuaConfig` in home-manager
    # >= 25.11. Bumping stateVersion to 26.05 later will remove the legacy
    # default warnings for gtk / firefox / etc.
  };

  # LazyVim starter config. `require("config.lazy")` from extraLuaConfig above
  # hits this file and boots LazyVim + Tokyo Night.
  xdg.configFile."nvim/lua/config/lazy.lua".text = ''
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not (vim.uv or vim.loop).fs_stat(lazypath) then
      local lazyrepo = "https://github.com/folke/lazy.nvim.git"
      local out = vim.fn.system({
        "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath,
      })
      if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
          { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
          { out, "WarningMsg" },
          { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
      end
    end
    vim.opt.rtp:prepend(lazypath)

    require("lazy").setup({
      spec = {
        { "LazyVim/LazyVim", import = "lazyvim.plugins" },
        { "folke/tokyonight.nvim", lazy = true, priority = 1000 },
      },
      defaults = { lazy = true, version = false },
      install = { colorscheme = { "tokyonight", "habamax" } },
      checker = { enabled = false },
    })
  '';

  # TODO Phase 2b: pin LazyVim + Tokyo Night as flake inputs and drop them as
  # xdg.configFile entries so plugin state stops floating.
}
