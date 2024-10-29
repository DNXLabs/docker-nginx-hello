VERSION = 1.0.1
IMAGE_NAME ?= dnxsolutions/nginx-hello:$(VERSION)
IMAGE_NAME_ECR = public.ecr.aws/dnxsolutions/nginx-hello:$(VERSION)
TAG = $(VERSION)

build:
	docker buildx build --platform=linux/amd64,linux/arm64,linux/arm/v7 -t $(IMAGE_NAME) -t $(IMAGE_NAME_ECR) .
	docker buildx build --load -t $(IMAGE_NAME) .

push-dockerhub:
	docker buildx build --push -t $(IMAGE_NAME) .

push-ecr: login-ecr
	docker buildx build --push -t $(IMAGE_NAME_ECR) .

login-ecr:
	aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws

shell:
	docker run --rm -it -v ~/.aws:/root/.aws -v $(PWD):/opt/app $(IMAGE_NAME) bash

gitTag:
	-git tag -d $(TAG)
	-git push origin :refs/tags/$(TAG)
	git tag $(TAG)
	git push origin $(TAG)
