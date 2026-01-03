{ pkgs, ... }:

{
  programs = {
      vim = {
          enable = true;
          defaultEditor = true;
          extraConfig = ''
            set so=7
            set ruler
            set cmdheight=1
            set hid
            set whichwrap+=<,>,h,l
            set ignorecase
            set smartcase
            set hlsearch
            set incsearch
            set lazyredraw
            set magic
            set showmatch
            set mat=2
            set noerrorbells
            set novisualbell
            set t_vb=
            set tm=500
            syntax enable
            set regexpengine=0
            set background=dark
            set encoding=utf8
            set ffs=unix,dos,mac
            set nobackup
            set nowb
            set noswapfile
            set nocompatible
            set expandtab
            set smarttab
            set shiftwidth=4
            set tabstop=4 softtabstop=0
            set lbr
            set tw=500
            set laststatus=2
          '';
          settings = {
              relativenumber = true;
          };
      };
  };
}

