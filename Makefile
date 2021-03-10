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

	@ make build-image-debian
	@ make build-image-fedora

build-image-debian: linux := debian
build-image-fedora: linux := fedora

build-image-debian build-image-fedora: _build-image

_build-image:

	docker build \
		--file="$(project_directory)/docker/development/$(linux)/Dockerfile" \
		--tag=$(docker_image_repository):$(docker_image_version)-$(linux) \
		--tag=$(docker_image_repository):latest-$(linux) \
		--build-arg="VERSION=$(docker_image_version)" \
		"$(project_directory)/docker/development/$(linux)"

######################################################################################################################################################

run-image-debian: linux := debian
run-image-fedora: linux := fedora

run-image-debian run-image-fedora: _run-image

_run-image: _build-image

	docker run \
		-it \
		--rm \
		$(docker_image_repository):$(docker_image_version)-$(linux) \
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

	@ make deploy-image-debian
	@ make deploy-image-fedora

deploy-image-debian: linux := debian
deploy-image-fedora: linux := fedora

deploy-image-debian deploy-image-fedora: _deploy-image

_deploy-image: _build-image

	docker push $(docker_image_repository):$(docker_image_version)-$(linux)
	docker push $(docker_image_repository):latest-$(linux)

######################################################################################################################################################

.PHONY: build-images build-image-debian build-image-fedora \
		run-image-debian run-image-fedora \
		pull-jupyter run-jupyter \
		deploy-images deploy-image-debian deploy-image-fedora

######################################################################################################################################################

help:

	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help

################################################################################################################################################################
