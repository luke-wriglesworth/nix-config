{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
# Configs common between all machines
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    inputs.stylix.homeManagerModules.stylix
  ];
  home.packages = with pkgs; [dust];
  nixpkgs.config.allowUnfree = true;
  stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetbrainsMono Nerd Font Mono";
      };
      serif = config.stylix.fonts.sansSerif;
      sansSerif = {
        package = pkgs.nerd-fonts.noto;
        name = "NotoSans Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
  programs = {
    btop.enable = true;
    htop.enable = true;
    eza = {
      enable = true;
      enableZshIntegration = true;
    };
    bat.enable = true;
    ripgrep-all.enable = true;
    ripgrep.enable = true;
    mcfly = {
      enable = true;
      enableZshIntegration = true;
    };
    fd.enable = true;
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    home-manager.enable = true;
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    zellij = {
      enable = true;
      enableZshIntegration = true;
      attachExistingSession = true;
      settings = {
        show_startup_tips = false;
      };
    };

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;

      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = ./p10k-config;
          file = "p10k.zsh";
        }
      ];
      shellAliases = {
        "cfg" = "nvim ~/.nixos/config/nixos/configuration.nix";
        "hm" = "nvim ~/.nixos/home/common/home.nix";
      };
    };

    wezterm = {
      enable = true;
      enableZshIntegration = true;
      extraConfig = ''
        local config = wezterm.config_builder()
                   config.font = wezterm.font "JetbrainsMono Nerd Font"
                   config.enable_wayland = true
                   config.audible_bell = "Disabled"
        config.window_close_confirmation = 'NeverPrompt'
             			config.enable_tab_bar = false
                   config.window_padding = {
        	left = '1cell',
        	right = '1cell',
        	top =0,
        	bottom = 0,
        }
        ${lib.optionalString pkgs.stdenv.isLinux "config.window_decorations = 'NONE'"}
        ${
          if pkgs.stdenv.isDarwin
          then "config.font_size = 16.0"
          else "config.font_size = 14.0"
        }
        return config
      '';
    };

    ghostty = {
      enable = true;
      enableZshIntegration = true;
      package =
        if pkgs.stdenv.isLinux
        then pkgs.ghostty
        else null;
      settings = {
        font-family = "${config.stylix.fonts.monospace.name}";
        font-size = 13;
        confirm-close-surface = false;
      };
    };

    nixvim = {
      enable = true;
      extraPackages = with pkgs; [
        nodejs
        alejandra
        black
        nodePackages_latest.prettier
        stylua
        yamlfmt
        statix
        python313Packages.flake8
      ];
      extraPlugins = with pkgs.vimPlugins; [
        leetcode-nvim
      ];
      extraConfigLua = "require('leetcode').setup({lang=rust})";
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
        lazygit.enable = true;
        molten = {
          enable = true;
          python3Dependencies = p: with p; [ipykernel plotly kaleido pyperclip cairosvg jupyter-client nbformat pynvim];
        };
        bufferline.enable = true;
        oil.enable = true;
        gitsigns.enable = true;
        nui.enable = true;
        illuminate.enable = true;
        vim-be-good.enable = true;
        web-devicons.enable = true;
        lualine.enable = true;
        ts-autotag.enable = true;
        telescope = {
          enable = true;
          #highlightTheme = "nord";
          keymaps = {
            "<leader>ff" = "find_files";
            "<leader>fg" = "live_grep";
            "<leader>fb" = "buffers";
            "<leader>fh" = "help_tags";
          };
          extensions = {
            fzf-native.enable = true;
            file-browser.enable = true;
          };
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
            query
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
            format_on_save = ''              {
                                  timeout_ms = 500,
                                  lsp_format = "fallback",
                            	}'';
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
                formatting.command = ["alejandra"];
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
