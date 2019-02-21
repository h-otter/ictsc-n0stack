GOOS=linux
GOARCH=amd64
GOCMD=go
VERSION=$(shell cat VERSION)

# --- Build ---
build-n0core:
	GOOS=${GOOS} GOARCH=${GOARCH} go build -o bin/n0core -ldflags "-X main.version=$(VERSION)" -v .

# -- Maintenance ---
.PHONY: vendor
vendor:
	go mod vendor

.PHONY: vendor-on-docker
vendor-on-docker:
	docker run -it --rm \
		-v $(PWD)/.go-build:/root/.cache/go-build/ \
		-v $(PWD):/go/src/github.com/h-otter/ictsc-n0stack \
		-w /go/src/github.com/h-otter/ictsc-n0stack \
		-e GO111MODULE=on \
		n0stack/build-go \
			make vendor
	sudo chown -R $(USER) vendor

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

update-n0stack:
	mkdir -p vendor/github.com/n0stack
	cp -r ../../n0stack/n0stack vendor/github.com/n0stack
	rm -rf vendor/github.com/n0stack/n0stack/vendor
