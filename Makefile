help:
	@echo "make list           #=> Show file list for deployment"
	@echo "make update         #=> Fetch changes for this repo"
	@echo "make deploy         #=> Create symlink to home directory"
	@echo "make init           #=> Setup environment settings"
	@echo "make install        #=> Run make update, deploy, init"
	@echo "make clean          #=> Remove the dotfiles and this repo"

list:
	@echo "make list"

update:
	@echo "make update"

test:
	@echo "make test"

deploy:
	@echo '==> Start to deploy dotfiles to home directory.'
	@echo ''

init:
	@echo "make init"
