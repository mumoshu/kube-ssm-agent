build:
	docker build . -t mumoshu/aws-ssm-agent:canary

push:
	docker push mumoshu/aws-ssm-agent:canary

run:
	docker run --rm -it mumoshu/aws-ssm-agent:canary

deploy:
	hack/deploy
