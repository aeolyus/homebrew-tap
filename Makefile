IMAGE ?= homebrew/brew:latest
USER ?= aeolyus
REPO ?= homebrew-tap
TAP ?= $(USER)/$(REPO)
TAP_PATH ?= /$(TAP)
USER_PATH ?= /$(USER)

default: help

.PHONY: brew-shell
brew-shell: ## Interactive container with brew installed
	docker run --rm -itv $$(pwd):$(TAP_PATH) $(IMAGE) bash

.PHONY: test
test: ## Run brew audit on the formula in a docker container
	docker run --rm -v $$(pwd):$(TAP_PATH) $(IMAGE) sh -c \
		'brew untap homebrew/core \
		&& cp -r $(USER_PATH) $$(brew --repository)/Library/Taps/ \
		&& for file in $(TAP_PATH)/Formula/*; \
		do \
			brew audit --verbose --strict --online --formula \
			"$$(basename $${file%.rb})"; \
		done'

.PHONY: test-install
test-install: ## Test install inside a homebrew docker container
	docker run --rm -v $$(pwd):$(TAP_PATH) $(IMAGE) sh -c \
		'brew untap homebrew/core \
		&& cp -r $(USER_PATH) $$(brew --repository)/Library/Taps/ \
		&& for file in $(TAP_PATH)/Formula/*; \
		do \
			brew install --verbose "$$(basename $${file%.rb})"; \
		done'

.PHONY: help
help: Makefile ## Print this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; \
		{printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
