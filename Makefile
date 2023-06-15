IMAGE ?= homebrew/brew:latest
TAP ?= aeolyus/tap
TAP_PATH ?= /home/linuxbrew/$(TAP)

.PHONY: test testinstall help
default: help

brew-shell: ## Interactive container with brew installed
	docker run --rm -itv $$(pwd):$(TAP_PATH) $(IMAGE) bash

test: ## Run brew audit on the formula in a docker container
	docker run --rm -v $$(pwd):$(TAP_PATH) $(IMAGE) sh -c \
		"brew untap homebrew/core \
		&& (ls $(TAP_PATH)/Formula/*.rb || ls $(TAP_PATH)/*.rb) \
		| xargs -n1 brew audit --verbose --strict --online --formula"

test-install: ## Test install inside a homebrew docker container
	docker run --rm -v $$(pwd):$(TAP_PATH) $(IMAGE) sh -c \
		"brew untap homebrew/core \
		&& (ls $(TAP_PATH)/Formula/*.rb || ls $(TAP_PATH)/*.rb) \
		| xargs brew install --verbose"

help: Makefile ## Print this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; \
		{printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
