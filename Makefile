# Apache License 2.0

export project_name := open-space-toolkit-base
export project_version := $(shell git describe --tags --always)
export project_directory := $(shell git rev-parse --show-toplevel)

export docker_registry_path := openspacecollective
export docker_image_repository := $(docker_registry_path)/$(project_name)
export docker_image_version := $(project_version)

export jupyter_image := openspacecollective/open-space-toolkit-astrodynamics-jupyter:latest
export jupyter_port := 8888

build-image: ## Build image

	docker build \
		--file="$(project_directory)/docker/development/Dockerfile" \
		--tag=$(docker_image_repository):$(docker_image_version) \
		--tag=$(docker_image_repository):latest \
		--build-arg="VERSION=$(docker_image_version)" \
		"$(project_directory)"

.PHONY: build-image

run-image: build-image ## Run image

	docker run \
		-it \
		--rm \
		$(docker_image_repository):$(docker_image_version) \
		/bin/bash

.PHONY: run-image

pull-jupyter: ## Pull jupyter image

	docker pull $(jupyter_image)

.PHONY: pull-jupyter

run-jupyter: ## Run jupyter

	docker run \
		--publish=$(jupyter_port):8888 \
		--volume="$(project_directory)/notebooks:/notebooks" \
		--workdir=/notebooks \
		$(jupyter_image)

.PHONY: run-jupyter

run-and-edit-jupyter: ## Run and edit jupyter notebooks

	docker run \
		-it \
		--rm \
		--user=$(shell id -u) \
		--group-add=users \
		--publish=$(jupyter_port):8888 \
		--volume="$(project_directory)/notebooks:/notebooks" \
		--workdir=/notebooks \
		$(jupyter_image) \
		bash -c "pip install kaleido~=0.2; start-notebook.py --ServerApp.token=''"

.PHONY: run-and-edit-jupyter

deploy-image: build-image ## Deploy image

	docker push $(docker_image_repository):$(docker_image_version)
	docker push $(docker_image_repository):latest

.PHONY: deploy-image

help:

	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

export DOCKER_BUILDKIT = 1

.DEFAULT_GOAL := help
