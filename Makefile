######################################################################################################################################################

# @project        Libraries
# @file           Makefile
# @author         Lucas Brémond <lucas.bremond@gmail.com>
# @license        Apache License 2.0

######################################################################################################################################################

export project_name := library-base
export project_version := 0.1.8
export project_directory := $(shell git rev-parse --show-toplevel)

export docker_registry_path := openspacecollective
export docker_image_repository := $(docker_registry_path)/$(project_name)
export docker_image_version := $(project_version)

######################################################################################################################################################

build-images: build-image-debian build-image-fedora

build-image-debian:

	docker build \
	--file="$(project_directory)/docker/debian/Dockerfile" \
	--tag=$(docker_image_repository):$(docker_image_version)-debian \
	--tag=$(docker_image_repository):latest-debian \
	--build-arg="VERSION=$(docker_image_version)" \
	"$(project_directory)/docker/debian"

build-image-fedora:

	docker build \
	--file="$(project_directory)/docker/fedora/Dockerfile" \
	--tag=$(docker_image_repository):$(docker_image_version)-fedora \
	--tag=$(docker_image_repository):latest-fedora \
	--build-arg="VERSION=$(docker_image_version)" \
	"$(project_directory)/docker/fedora"

######################################################################################################################################################

run-image-debian: build-image-debian

	docker run \
	-it \
	--rm \
	$(docker_image_repository):debian-$(docker_image_version) \
	/bin/bash

run-image-fedora: build-image-fedora

	docker run \
	-it \
	--rm \
	$(docker_image_repository):fedora-$(docker_image_version) \
	/bin/bash

######################################################################################################################################################

deploy-images: deploy-image-debian deploy-image-debian

deploy-image-debian: build-image-debian

	docker push $(docker_image_repository):debian-$(docker_image_version)
	docker push $(docker_image_repository):debian-latest

deploy-image-fedora: build-image-fedora

	docker push $(docker_image_repository):fedora-$(docker_image_version)
	docker push $(docker_image_repository):fedora-latest

######################################################################################################################################################

.PHONY: build-images build-image-debian build-image-fedora \
		run-image-debian run-image-fedora \
		deploy-images deploy-image-debian deploy-image-fedora

######################################################################################################################################################
