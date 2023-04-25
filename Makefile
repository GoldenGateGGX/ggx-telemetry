ENVIRONMENT ?=
IMAGE_NAME = ggx-telemetry-frontend
IMAGE_TAG ?= latest
LATEST_COMMIT := $$(git rev-parse HEAD)
REGISTRY_HOST ?= ghcr.io/boostylabs

IMAGE_BACKUP = $(REGISTRY_HOST)/$(IMAGE_NAME)$(ENVIRONMENT):$(LATEST_COMMIT)
IMAGE_LATEST = $(REGISTRY_HOST)/$(IMAGE_NAME)$(ENVIRONMENT):$(IMAGE_TAG)

build_dist: ## Build dist folder that needed for frontend.
	cd frontend && npm install && npm run build

build_frontend: ## Build web-app docker image.
	make build_dist && DOCKER_BUILDKIT=1 docker build -f ./frontend/Dockerfile -t $(IMAGE_BACKUP) . && DOCKER_BUILDKIT=1 docker build -f ./frontend/Dockerfile -t $(IMAGE_LATEST) .

push_frontend: ## Push web-app docker image.
	docker push $(IMAGE_BACKUP) && docker push $(IMAGE_LATEST)

docker: ## Build and push all docker images.
	make build_frontend push_frontend
