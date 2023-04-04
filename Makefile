REPOS_PATH        := $(HOME)/work/repos

DOTFILES_EXCLUDES := .idea .DS_Store .git .gitmodules .gitignore
DOTFILES_TARGET   := $(wildcard .??*) bin
DOTFILES_FILES    := $(filter-out $(DOTFILES_EXCLUDES), $(DOTFILES_TARGET))

help:
	@echo "make list           #=> Show file list for deployment"
	@echo "make update         #=> Fetch changes for this repo"
	@echo "make deploy         #=> Create symlink to home directory"
	@echo "make init           #=> Setup environment settings"
	@echo "make install        #=> Run make update, deploy, init"
	@echo "make clean          #=> Remove the dotfiles"
	@echo "make anyenv         #=> Setup anyenv. Init and install plugins"

list:
	@echo "make list"
	@$(foreach val, $(DOTFILES_FILES), ls -dF $(val);)

init:
	@echo "make init"
	@mkdir -p $(REPOS_PATH)
	@DOTPATH=$(PWD) bash $(PWD)/etc/init/init.sh

deploy:
	@echo "==> Start to deploy dotfiles to home directory."
	@echo ""
	@$(foreach val, $(DOTFILES_FILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)

update:
	@echo "make update"
	git pull origin master
	git submodule init
	git submodule update
	git submodule foreach git pull origin master

install:
	@echo "make update deploy init"

clean:
	@echo "Remove dot files in your home directory..."
	@-$(foreach val, $(DOTFILES_FILES), rm -vrf $(HOME)/$(val);)
	# -rm -rf $(PWD)

anyenv:
	@echo "Setup anyenv"
	@$(anyenv init)
	@$(anyenv install --init)
	@$(echo $SHELL -l)
	@cd $(PWD)/.anyenv/plugins && git clone https://github.com/znz/anyenv-update.git
	@cd $(PWD)/.anyenv/plugins && git clone https://github.com/znz/anyenv-git.git

