all: build push

build:
	docker build -t ${DOCKER_USER}/nginx:1.7.7 .

push: build
	docker push ${DOCKER_USER}/nginx:1.7.7

test: build
	sudo docker run -i ${DOCKER_USER}/nginx:1.7.7 /bin/bash -l -c 'nginx -v'
