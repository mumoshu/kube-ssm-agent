TAG  ?= $(shell git describe --tags --abbrev=0 HEAD)

build:
	docker build . -t mumoshu/aws-ssm-agent:${TAG}

push:
	docker push mumoshu/aws-ssm-agent:${TAG}

run:
	docker run --rm -it mumoshu/aws-ssm-agent:${TAG}

deploy:
	hack/deploy
