IMAGE_NAME = "centos-with-systemd-enabled"

build: Dockerfile
	@docker build --no-cache -t $(IMAGE_NAME) .

run:
	@docker run --privileged -it --name $(IMAGE_NAME) --rm $(IMAGE_NAME)
