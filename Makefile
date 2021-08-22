SCRIPT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))


.DEFAULT_GOAL=help
.PHONY: help
help:  ## help for this Makefile
	@awk -F ':|##' \
		'/^[^\t].+?:.*?##/ {\
			printf "\033[36m%-30s\033[0m %s\n", $$1, $$NF \
		 }' $(MAKEFILE_LIST)

tmux:  ## start tmux
	tmuxp load tmux.yaml

.PHONY: clean
clean:  ## remove output files
	rm -rf output/*
