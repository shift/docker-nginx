all: build push

build:
	docker build -t ${DOCKER_USER}/nginx:stable .

push: build
	docker push ${DOCKER_USER}/nginx:stable

test: build
	docker run -i ${DOCKER_USER}/nginx:stable /bin/bash -l -c 'nginx -v'
