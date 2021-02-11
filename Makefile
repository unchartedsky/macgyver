SHELL := /bin/bash

IMAGES = $(shell find * -type f -name 'Dockerfile' -not -path "." | xargs -I {} dirname {})
GIT_COMMIT_ID=$(shell git rev-parse --short HEAD)
export GIT_COMMIT_ID
GIT_BRANCH=$(shell git describe --abbrev=1 --tags --always)
export GIT_BRANCH

REPO=ghcr.io/unchartedsky

image:
	@ for IMAGE in $(IMAGES) ; do \
		echo Building $(REPO)/$${IMAGE}:$(GIT_COMMIT_ID) ; \
		docker build -t $(REPO)/$${IMAGE}:$(GIT_COMMIT_ID) $${IMAGE} ; \
		docker tag $(REPO)/$${IMAGE}:$(GIT_COMMIT_ID) $(REPO)/$${IMAGE}:latest ; \
	done

deploy: image
	@ for IMAGE in $(IMAGES) ; do \
		echo Pushing $(REPO)/$${IMAGE}:$(GIT_COMMIT_ID) ; \
		docker push $(REPO)/$${IMAGE}:$(GIT_COMMIT_ID) ; \
		docker push $(REPO)/$${IMAGE}:latest ; \
	done

.PHONY: clean

clean: ;

cleanall: clean ;
