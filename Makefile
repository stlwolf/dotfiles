REPOS_PATH        := $(HOME)/work/repos

DOTFILES_EXCLUDES := .idea .DS_Store .git .gitmodules .gitignore .config
DOTFILES_TARGET   := $(wildcard .??*) bin
DOTFILES_FILES    := $(filter-out $(DOTFILES_EXCLUDES), $(DOTFILES_TARGET))
CONFIG_FILES      := $(shell find .config -type f)

.PHONY: help list init deploy update install clean lint validate

help:
	@echo "make list           #=> Show file list for deployment"
	@echo "make update         #=> Fetch changes for this repo"
	@echo "make deploy         #=> Create symlink to home directory"
	@echo "make init           #=> Setup environment settings"
	@echo "make install        #=> Run make update, deploy, init"
	@echo "make clean          #=> Remove the dotfiles"
	@echo "make lint           #=> Run shellcheck on scripts"
	@echo "make validate       #=> Check symlink integrity"

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

lint:
	@echo "==> Running shellcheck..."
	@shellcheck -x bin/* 2>/dev/null || true
	@shellcheck -x etc/init/*.sh etc/init/osx/*.sh etc/lib/*.sh 2>/dev/null || true
	@shellcheck -x scripts/*.sh 2>/dev/null || true
	@shellcheck -x .bashrc .bash_profile 2>/dev/null || true
	@echo "==> Done."

validate:
	@echo "==> Checking symlink integrity..."
	@$(foreach val, $(DOTFILES_FILES), \
		if [ -L "$(HOME)/$(val)" ]; then \
			if readlink "$(HOME)/$(val)" | grep -q "$(PWD)"; then \
				echo "OK: $(val)"; \
			else \
				echo "Warning: $(val) points elsewhere"; \
			fi; \
		else \
			echo "Missing: $(val)"; \
		fi; \
	)
	@echo "==> Done."

