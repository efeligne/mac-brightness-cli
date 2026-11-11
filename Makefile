.PHONY: build
build:
	swift build -c release --arch arm64 --arch x86_64

.PHONY: release-patch
release-patch:
	@./scripts/release.sh patch

.PHONY: release-minor
release-minor:
	@./scripts/release.sh minor

.PHONY: release-major
release-major:
	@./scripts/release.sh major
