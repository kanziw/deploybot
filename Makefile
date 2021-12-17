GOPATH:=$(shell go env GOPATH)
APP?=deploybot

.PHONY: init
## init: initialize the application
init:
	go mod download

.PHONY: build
## build: build the application(api)
build:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -ldflags="-w -s" -o bin/${APP}.linux.amd64 cmd/main.go
	CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -a -installsuffix cgo -ldflags="-w -s" -o bin/${APP}.linux.arm64 cmd/main.go
	CGO_ENABLED=0 go build -a -installsuffix cgo -ldflags="-w -s" -o bin/${APP} cmd/main.go

.PHONY: run
## run: run the application(api)
run:
	go run -v -race cmd/main.go

.PHONY: format
## format: format files
format:
	@go install golang.org/x/tools/cmd/goimports@v0.1.6
	@go install github.com/kanziw/importsort@latest
	goimports -local github.com/kanziw -w .
	importsort -s github.com/kanziw -w $$(find . -name "*.go")
	gofmt -s -w .
	go mod tidy

.PHONY: test
## test: run tests
test:
	@go install github.com/rakyll/gotest@v0.0.6
	gotest -p 1 -race -cover -v ./...

.PHONY: coverage
## coverage: run tests with coverage
coverage:
	@go install github.com/rakyll/gotest@v0.0.6
	gotest -p 1 -race -coverprofile=coverage.txt -covermode=atomic -v ./...

.PHONY: lint
## lint: check everything's okay
lint:
	@go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.43.0
	golangci-lint run ./...

.PHONY: generate
## generate: generate source code for mocking
generate:
	@go install golang.org/x/tools/cmd/stringer@v0.1.6
	@go install github.com/golang/mock/mockgen@v1.6.0
	go generate ./...
	$(MAKE) format

.PHONY: help
## help: prints this help message
help:
	@echo "Usage: \n"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':'
