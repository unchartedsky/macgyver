TAG=latest
BIN=macgyver
IMAGE=docker.pkg.github.com/unchartedsky/macgyver/macgyver

image:
	docker build -t $(IMAGE):$(TAG) .

deploy: image
	docker push $(IMAGE):$(TAG)

run: image
	docker run -it $(IMAGE):$(TAG)

.PHONY: clean

clean: ;

cleanall: clean ;
