## dotfiles

#### Settings
- KeyRepeat
  - `defaults write -g KeyRepeat 1`

#### Shell

- Set brew path
```
  eval "$(/opt/homebrew/bin/brew shellenv)"
```

- Change brew bash

  - M1X ~
  ```
    sudo bash -c 'echo /opt/homebrew/bin/bash >> /etc/shells'
    chsh -s /opt/homebrew/bin/brew
  ```

  - IntelCPU
  ```
    sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells'
    chsh -s /usr/local/bin/bash
  ```

#### Repository

- AWSP - AWS Profile Switcher
  - [fork/awsp](https://github.com/stlwolf/awsp)

#### Editor

- Vim
  - [dein](https://github.com/Shougo/dein.vim)

- Color scheme
  - [iceberg](https://github.com/cocopon/iceberg.vim)
  - [lucario](https://github.com/raphamorim/lucario)
  - [tender](https://github.com/jacoborus/tender.vim)
  - [gruvbox](https://github.com/morhetz/gruvbox)

- Fonts
  - [Rounded Mgen+](http://jikasei.me/font/rounded-mgenplus/)

#### Env

- [asdf](https://asdf-vm.com/)
```shell
  # plugin install example
  
  # nodejs
  asdf plugin-add nodejs
  asdf install nodejs latest
  asdf install nodejs 16.15.0
  asdf global nodejs 16.15.0

  # golang
  asdf plugin-add golang
  asdf install golang 1.18.1
  asdf global golang 1.18.1
  
  # python
  asdf plugin-add python
  asdf install python latest
  asdf global python 3.10.4
```

- [fzf](https://github.com/junegunn/fzf)
```shell
  # If it doesn't work, it needs to be initialized
  # https://github.com/junegunn/fzf?tab=readme-ov-file#using-homebrew
  $(brew --prefix)/opt/fzf/install
```
