IMAGE ?= homebrew/brew:latest
TAP ?= aeolyus/tap
CONTAINER_TAP_PATH ?= /home/linuxbrew/.linuxbrew/Homebrew/Library/Taps/aeolyus/homebrew-tap

.PHONY: test testinstall help
default: help

brew-shell: ## Interactive container with brew installed
	docker run --rm -itv .:$(CONTAINER_TAP_PATH) $(IMAGE) bash

test: ## Run brew audit on the formula in a docker container
	docker run --rm -v .:$(CONTAINER_TAP_PATH) $(IMAGE) sh -c \
		"brew untap homebrew/core \
		&& brew tap-info $(TAP) --json \
		| jq -r '.[]|(.formula_names[],.cask_tokens[])' \
		| xargs -n1 brew audit --strict --online"

test-install: ## Test install inside a homebrew docker container
	docker run --rm -v .:$(CONTAINER_TAP_PATH) $(IMAGE) sh -c \
		"brew untap homebrew/core \
		&& brew tap-info $(TAP) --json \
		| jq -r '.[]|(.formula_names[],.cask_tokens[])' \
		| xargs brew install"

help: Makefile ## Print this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; \
		{printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
