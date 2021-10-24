# dotfiles

## usage

```sh
$ git clone --recursive https://github.com/nakahiro386/dotfiles.git ~/repo/github.com/nakahiro386/dotfiles
$ cd !$
$ git remote set-url origin git@github.com:nakahiro386/dotfiles.git
$ ./init.sh --dry-run
$ ./init.sh

$ ./install_anyenv.sh --dry-run
$ ./install_anyenv.sh
$ anyenv git co master

$ cd ~/.vim
$ git switch master
$ git remote set-url origin git@github.com:nakahiro386/vimfiles.git

```

## [jesseduffield/lazydocker](https://github.com/jesseduffield/lazydocker) のinstall

* docker版の場合、volume mountしてもdocker-composeを利用できないためバイナリ版を利用する。
```sh
$ sudo curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
```

