This script is a submudule, and it needs to be located at [main-git-project]/.devcontainer/.docker-image-builder. It relies on folder called [main-git-project]/.devcontainer/.docker-image-builder-archive. This is where the generated images Dockerfile and etc. are stored.

# my-image-builder.sh Usage Guide

This script is used to build and optionally push Docker images. The image details are provided through the `--imagepath` argument in a special format.

## Arguments

- `--imagepath`: Specifies the details of the Docker image to build. The value should be in the following format: `__owner__ownerValue__project__projectValue__image__imageValue__tag__tagValue`
- `--push-to-hub`: If this argument is provided, the script will push the built image to Docker Hub.

## Imagepath Format

The `--imagepath` argument value should be in the following format: `__owner__ownerValue__project__projectValue__image__imageValue__tag__tagValue`

Here's what each part means:

- `ownerValue`: The owner of the Docker image. This will be used as the Docker Hub username when pushing the image.
- `projectValue`: The project that the Docker image belongs to. This will be included in the Docker image name.
- `imageValue`: The name of the Docker image.
- `tagValue`: The tag of the Docker image.

## Examples

Here are some example usages of the script:

Build a Docker image without pushing to Docker Hub:


bash my-image-builder.sh --imagepath '__owner__dtuait__project__api-security-ait-dtu-dk__image__app-main__tag__python-3.10-bullseye-django-4.2.11-27-03-2024-venv-myversion-1.0.5'
bash my-image-builder.sh --imagepath '__owner__dtuait__project__api-security-ait-dtu-dk__image__app-main__tag__python-3.10-bullseye-django-4.2.11-27-03-2024-venv-myversion-1.0.5' --push-to-hub
