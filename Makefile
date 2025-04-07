.PHONY: help
help: ## Display this help message
	@echo "Usage:"
	@echo "  make <target>"
	@echo
	@echo "Targets:"
	@awk 'BEGIN {FS = ":.*?## "}; \
		/^##@/ {print ""; print "  \033[1m//\033[0m "substr($$0, 5); next} \
		/^[a-zA-Z_.-]+:.*?## / {printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: init.local.gitconfig
init.local.gitconfig: ## Add/Overwrite your .gitconfig.local with the template
	@cat ./templates/.gitconfig.local > ~/.gitconfig.local
	@echo "Added local .gitconfig to ~/.gitconfig.local"

.PHONY: init.local.ssh.config
init.local.ssh.config: ## Add/Overwrite your .ssh/config.local with the template
	@cat ./templates/.ssh.config.local > ~/.ssh/config.local
	@echo "Added local config.local to ~/.ssh/config.local, ensure you're ssh key is correct"

.PHONY: init.local.zprofile
init.local.zprofile: ## Create the ~/.zprofile.local if needed
	@touch ~/.zprofile.local
	@echo "Created ~/.zprofile.local"

.PHONY: init.local.zshrc
init.local.zshrc: ## Create the ~/.zshrc.local if needed
	@touch ~/.zshrc.local
	@echo "Created ~/.zshrc.local"

.PHONY: mac.legacy-migrate
mac.legacy-migrate: ## Migrate to newer version where configs have their own directory
	@sh $(PWD)/utils/legacy-migrate.sh
	@sh $(PWD)/macos
