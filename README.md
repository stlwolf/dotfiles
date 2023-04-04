## dotfiles

#### Settings
- KeyRepeat
  - `defaults write -g KeyRepeat 1`

#### Terminal

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

- [anyenv](https://github.com/anyenv/anyenv)
```shell
  # Makefile
  make anyenv

  # official setup e.g.
  anyenv install -l
  anyenv install nodenv
  exec $SHELL -l
  nodenv install 8.10.0
  nodenv global 8.10.0
  nodenv rehash
```
