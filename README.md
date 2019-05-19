## dotfiles

#### Application

- Localization
  - [Google 日本語入力](https://www.google.co.jp/ime/)

#### Terminal

- Change brew bash
```
  sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells'
  chsh -s /usr/local/bin/bash
```

#### Editor

- Vim
  - [dein](https://github.com/Shougo/dein.vim)

- Color scheme
  - [lucario](https://github.com/raphamorim/lucario)
  - [tender](https://github.com/jacoborus/tender.vim)

- Fonts
  - [自家製Rounded M+](http://jikasei.me/font/rounded-mplus/)
  - [BackUP](https://github.com/stlwolf/fonts)

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
