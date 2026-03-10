.PHONY: test test-smoke test-bats shellcheck package-check

test: shellcheck test-smoke test-bats

shellcheck:
	shellcheck bin/* lib/*.sh tests/run_tests.sh

test-smoke:
	bash tests/run_tests.sh

test-bats:
	bats tests/bats

package-check:
	tar -czf /tmp/bash-toolbox.tar.gz bin lib tests install.sh README.md CHEATSHEET.md FILES_EXPLAINED.md Makefile
	tar -tzf /tmp/bash-toolbox.tar.gz >/dev/null
