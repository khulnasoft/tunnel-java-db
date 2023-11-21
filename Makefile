LDFLAGS=-ldflags "-s -w"
GO_SRCS := $(shell find . -name *.go)

.PHONY: test
test:
	go test -v -short -race -timeout 30s -coverprofile=coverage.txt -covermode=atomic ./...

.PHONY: build
build: tunnel-java-db

tunnel-java-db: $(GO_SRCS)
	go build $(LDFLAGS) ./cmd/tunnel-java-db

.PHONY: db-crawl
db-crawl: tunnel-java-db
	./tunnel-java-db --cache-dir ./cache crawl

.PHONY: db-build
db-build: tunnel-java-db
	./tunnel-java-db --cache-dir ./cache build

.PHONY: db-compress
db-compress: cache/*
	tar cvzf cache/db/javadb.tar.gz -C cache/db/ tunnel-java.db metadata.json

.PHONY: clean
clean:
	rm -rf cache/
