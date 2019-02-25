GOOS=linux
GOARCH=amd64
GOCMD=go
VERSION=$(shell echo ICTSC-`cat vendor/github.com/n0stack/n0stack/VERSION`)

# --- Build ---
build-n0core:
	GOOS=${GOOS} GOARCH=${GOARCH} go build -o bin/n0core -ldflags "-X main.version=$(VERSION)" -v .

# -- Maintenance ---
.PHONY: clean
clean:
	# go clean
	docker-compose down
	# sudo rm -rf .go-build
	# sudo rm -rf bin/*
	sudo rm -rf sandbox/*
	# sudo rm -rf vendor

logs:
	docker-compose logs -f api

.PHONY: vendor
vendor:
	rm -rf ./vendor
	cp -r ../../n0stack/n0stack/vendor ./vendor
	mkdir -p vendor/github.com/n0stack/n0stack
	cp -r ../../n0stack/n0stack/VERSION vendor/github.com/n0stack/n0stack/
	cp -r ../../n0stack/n0stack/n0core vendor/github.com/n0stack/n0stack/n0core
	cp -r ../../n0stack/n0stack/n0proto.go vendor/github.com/n0stack/n0stack/n0proto.go
