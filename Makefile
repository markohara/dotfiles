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
	echo "Added local .gitconfig to ~/.gitconfig.local"

.PHONY: init.local.localrc
init.local.localrc: ## Create the .localrc if needed
	@touch ~/.localrc
	echo "Created ~/.localrc"
