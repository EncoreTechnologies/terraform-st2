ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

# cleanup CI environment
.PHONY: clean
clean:
	@echo
	@echo "==================== clean ===================="
	@echo
	find "$(ROOT_DIR)" -type d -name '.terraform' | xargs -r -t -n1 rm -rf
	find "$(ROOT_DIR)" -name 'terraform.tfstate*' | xargs -r -t -n1 rm -rf
