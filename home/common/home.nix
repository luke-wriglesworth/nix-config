{
  pkgs,
  inputs,
  ...
}:
# Configs common between all machines
{
  imports = [inputs.nixvim.homeManagerModules.nixvim];
  home.file = {};
  nixpkgs.config.allowUnfree = true;
  xdg.configFile."starship.toml".source = ./starship.toml;
  programs = {
    home-manager.enable = true;
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
    };

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      initExtra = ''
        eval "$(starship init zsh)"
      '';
    };

    wezterm = {
      enable = true;
      enableZshIntegration = true;
      extraConfig = ''
        local config = wezterm.config_builder()
        config.font_size = 12.0
        config.font = wezterm.font "JetbrainsMono Nerd Font"
        config.color_scheme = 'Gruvbox Dark (Gogh)'
        config.enable_wayland = false
        config.audible_bell = "Disabled"
        config.window_padding = {
          left = '1cell',
          right = '1cell',
          top = '0.5cell',
          bottom = '0.5cell',
        }
        config.window_decorations = "TITLE | RESIZE"
        return config
      '';
    };

    nixvim = {
      enable = true;
      extraPackages = with pkgs; [
        alejandra
        black
        nodePackages_latest.prettier
        rubyfmt
        stylua
        yamlfmt
      ];
      extraPlugins = [pkgs.vimPlugins.gruvbox];
      colorscheme = "gruvbox";
      opts = {
        number = true;
        autoindent = true;
        spell = true;
        termguicolors = true;
        smartcase = true;
        relativenumber = true;
        tabstop = 4;
        softtabstop = 4;
        shiftwidth = 4;
      };

      autoCmd = [
        {
          event = "FileType";
          pattern = "nix";
          command = "setlocal tabstop=2 shiftwidth=2 softtabstop=2";
        }
      ];

      plugins = {
        bufferline.enable = true;
        oil.enable = true;
        illuminate.enable = true;
        web-devicons.enable = true;
        lualine.enable = true;
        treesitter-context.enable = true;
        ts-autotag.enable = true;
        ts-context-commentstring = {
          enable = true;
          disableAutoInitialization = false;
        };
        treesitter = {
          enable = true;
          nixvimInjections = true;
          settings = {
            highlight.enable = true;
            highlight.additional_vim_regex_highlighting = true;
            indent.enable = true;
            folding.enable = true;
            autopairs.enable = true;
          };
          grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
            bash
            lua
            json
            make
            markdown
            nix
            regex
            toml
            yaml
            xml
            vim
            c
            cpp
            rust
          ];
        };

        cmp = {
          enable = true;
          autoEnableSources = true;
          settings = {
            sources = [
              {name = "nvim_lsp";}
              {name = "luasnip";}
              {name = "buffer";}
              {name = "path";}
            ];
            mapping = {
              "<CR>" = "cmp.mapping.confirm({ select = true })";
              "<Down>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
              "<Up>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
              "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
              "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
              "<C-d>" = "cmp.mapping.scroll_docs(-4)";
              "<C-f>" = "cmp.mapping.scroll_docs(4)";
              "<C-Space>" = "cmp.mapping.complete()";
            };
          };
        };

        lint = {
          enable = true;
          lintersByFt = {
            c = ["cpplint"];
            cpp = ["cpplint"];
            go = ["golangci-lint"];
            nix = ["statix"];
            lua = ["selene"];
            python = ["flake8"];
            javascript = ["eslint_d"];
            javascriptreact = ["eslint_d"];
            typescript = ["eslint_d"];
            typescriptreact = ["eslint_d"];
            json = ["jsonlint"];
            java = ["checkstyle"];
            haskell = ["hlint"];
            bash = ["shellcheck"];
          };
        };
        conform-nvim = {
          enable = true;
          settings = {
            formatters_by_ft = {
              css = ["prettier"];
              html = ["prettier"];
              json = ["prettier"];
              lua = ["stylua"];
              markdown = ["prettier"];
              nix = ["alejandra"];
              python = ["black"];
              ruby = ["rubyfmt"];
              yaml = ["yamlfmt"];
            };
          };
        };
        lsp = {
          enable = true;
          servers = {
            bashls.enable = true;
            jsonls.enable = true;
            lua_ls = {
              enable = true;
              settings.telemetry.enable = false;
            };
            marksman.enable = true;
            nixd = {
              enable = true;
              settings = {
                formatting.command = ["nixpkgs-fmt"];
              };
            };
            pylsp = {
              enable = true;
              settings.plugins = {
                black.enabled = true;
                flake8.enabled = false;
                isort.enabled = true;
                jedi.enabled = false;
                mccabe.enabled = false;
                pycodestyle.enabled = false;
                pydocstyle.enabled = true;
                pyflakes.enabled = false;
                pylint.enabled = true;
                rope.enabled = false;
                yapf.enabled = false;
              };
            };
            yamlls.enable = true;
            rust_analyzer = {
              enable = true;
              installRustfmt = true;
              installCargo = true;
              installRustc = true;
            };
          };
        };
      };
    };
  };
}
