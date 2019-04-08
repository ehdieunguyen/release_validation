NAME = ehdevops/release_validation
VERSION = 0.0.1
mkfile_path := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

build:
	docker build -t $(NAME):$(VERSION) -t $(NAME):latest $(mkfile_path)

release: build
	docker push $(NAME):$(VERSION)
	docker push $(NAME):latest
