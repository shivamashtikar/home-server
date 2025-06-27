# Name of the Docker image and container
IMAGE_NAME=home-server
CONTAINER_NAME=home-server
PORT=9000

# Build the Docker image
build:
	docker build -t $(IMAGE_NAME) .

# Run the Docker container
run:
	docker run -d --name $(CONTAINER_NAME) -p $(PORT):9000 $(IMAGE_NAME)

# Stop the running container
stop:
	docker stop $(CONTAINER_NAME) || true
	docker rm $(CONTAINER_NAME) || true

# Rebuild and run the container
rebuild: stop build run

# Show logs
logs:
	docker logs -f $(CONTAINER_NAME)

# Clean the image and container
clean: stop
	docker rmi $(IMAGE_NAME) || true
