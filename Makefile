REPOS_PATH        := $(HOME)/work/repos

DOTFILES_EXCLUDES := .idea .DS_Store .git .gitmodules .gitignore .config
DOTFILES_TARGET   := $(wildcard .??*) bin
DOTFILES_FILES    := $(filter-out $(DOTFILES_EXCLUDES), $(DOTFILES_TARGET))
CONFIG_FILES      := $(shell find .config -type f)

.PHONY: help list init deploy update install clean anyenv

help:
	@echo "make list           #=> Show file list for deployment"
	@echo "make update         #=> Fetch changes for this repo"
	@echo "make deploy         #=> Create symlink to home directory"
	@echo "make init           #=> Setup environment settings"
	@echo "make install        #=> Run make update, deploy, init"
	@echo "make clean          #=> Remove the dotfiles"

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
	@echo "==> Deploying .config directory and its subdirectories"
	@mkdir -p $(HOME)/.config
	@$(foreach file, $(CONFIG_FILES), \
		mkdir -p $(HOME)/$(dir $(file)); \
		ln -sfnv $(abspath $(file)) $(HOME)/$(file); \
	)

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
	@echo "Removing symlinks under .config directory and its subdirectories"
	@-$(foreach file, $(CONFIG_FILES), \
		if [ -L "$(HOME)/$(file)" ]; then \
			rm -v "$(HOME)/$(file)"; \
		fi; \
	)
	# -rm -rf $(PWD)


