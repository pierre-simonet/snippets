TARGET_PLATFORM = linux/amd64
IMAGE_NAME = "homemade-with-db2"
IMAGE_VERSION = "0.1"

build: Dockerfile
	@docker build --no-cache --platform $(TARGET_PLATFORM) -t $(IMAGE_NAME):$(IMAGE_VERSION) .

run:
	@docker run --privileged --rm --platform $(TARGET_PLATFORM) -it $(IMAGE_NAME):$(IMAGE_VERSION)