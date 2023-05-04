######################################################################################################################################################

# @project        Open Space Toolkit
# @file           Makefile
# @author         Lucas Brémond <lucas.bremond@gmail.com>
# @license        Apache License 2.0

######################################################################################################################################################

export project_name := open-space-toolkit-base
export project_version := $(shell git describe --tags --always)
export project_directory := $(shell git rev-parse --show-toplevel)

export docker_registry_path := openspacecollective
export docker_image_repository := $(docker_registry_path)/$(project_name)
export docker_image_version := $(project_version)

export jupyter_image := openspacecollective/open-space-toolkit-astrodynamics-jupyter:latest
export jupyter_port := 8888

######################################################################################################################################################

build-images: ## Build images

	@ make build-image

build-image:

	docker build \
		--file="$(project_directory)/docker/development/debian/Dockerfile" \
		--tag=$(docker_image_repository):$(docker_image_version)-debian \
		--tag=$(docker_image_repository):latest-debian \
		--build-arg="VERSION=$(docker_image_version)" \
		"$(project_directory)/docker/development/debian"

######################################################################################################################################################

run-image: build-image

	docker run \
		-it \
		--rm \
		$(docker_image_repository):$(docker_image_version)-debian \
		/bin/bash

pull-jupyter: ## Pull jupyter image

	docker pull $(jupyter_image)

run-jupyter: ## Run jupyter

	docker run \
		--publish=$(jupyter_port):8888 \
		--volume="$(project_directory)/notebooks:/notebooks" \
		--workdir=/notebooks \
		$(jupyter_image)

######################################################################################################################################################

deploy-images: ## Deploy images

	@ make deploy-image

deploy-image: build-image

	docker push $(docker_image_repository):$(docker_image_version)-debian
	docker push $(docker_image_repository):latest-debian

######################################################################################################################################################

.PHONY: build-images build-image \
		run-image \
		pull-jupyter run-jupyter \
		deploy-images deploy-image

######################################################################################################################################################

help:

	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help

################################################################################################################################################################
