ifeq ($(UNAME_S), Darwin)
	SED ?= gsed
else
	SED ?= sed
endif

check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $2, ($2))))

.PHONY: help
help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Release

.PHONY: bump-version
bump-version: ## This is used to bump the release version on main via a PR.
	@:$(call check_defined, OLD_VERSION)
	@:$(call check_defined, NEW_VERSION)

	git checkout main
	git pull
	git checkout -B bump-version main
	$(SED) -i 's/version: $(OLD_VERSION)/version: $(NEW_VERSION)/' charts/spire/Chart.yaml
	./helm-docs.sh
	git add charts/spire/{Chart.yaml,README.md}
	git commit -m "Bump Spire Helm Chart version from $(OLD_VERSION) to $(NEW_VERSION)" -s
	git push -u
	# gh pr create --base release \
	# 	--body ''
	# gh pr merge --auto -r
	@echo
	@echo "  Ensure to run 'make release-main' after this PR gets merged to trigger the release workflow"
	@echo

.PHONY: release-main
release-main: ## Once the bump-version PR is merged, this can be used to push the release.
	git checkout main
	git pull
	git checkout release
	git merge main
	git push
