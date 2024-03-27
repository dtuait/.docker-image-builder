#!/bin/bash

# Initialize push flag to false
PUSH_TO_HUB=false

# Process command-line arguments
while [ $# -gt 0 ]; do
    case "$1" in
        --push-to-hub)
            PUSH_TO_HUB=true
            ;;
        --imagepath)
            IMAGEPATH="$2"
            shift # Skip the argument value
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
    shift # Move to the next key or value
done

if [ -z "$IMAGEPATH" ]; then
    echo "Usage: $0 --imagepath '__owner__ownerValue__project__projectValue__image__imageValue__tag__tagValue'"
    exit 1
fi

# Extract owner, project, image, and tag from the IMAGEPATH
OWNER=$(echo "$IMAGEPATH" | sed -n 's/.*__owner__\([^_]*\).*/\1/p')
PROJECT=$(echo "$IMAGEPATH" | sed -n 's/.*__project__\([^_]*\).*/\1/p')
IMAGE=$(echo "$IMAGEPATH" | sed -n 's/.*__image__\([^_]*\).*/\1/p')
TAG=$(echo "$IMAGEPATH" | sed -n 's/.*__tag__\([^_]*\).*/\1/p')

# Construct the Docker image name using extracted values
IMAGE_NAME="$OWNER/$PROJECT-$IMAGE"

# Navigate to the script's directory
cd $IMAGEPATH

echo "Building Docker image: $IMAGE_NAME:$TAG..."
docker build -t "$IMAGE_NAME:$TAG" .

# Check if the build was successful
if [ $? -eq 0 ]; then
    echo "Docker image $IMAGE_NAME:$TAG successfully built."
    
    if $PUSH_TO_HUB; then
        echo "Pushing $IMAGE_NAME:$TAG to Docker Hub..."
        docker push "$IMAGE_NAME:$TAG"
        
        # Check if the push was successful
        if [ $? -eq 0 ]; then
            echo "Docker image $IMAGE_NAME:$TAG successfully pushed to Docker Hub."
        else
            echo "Failed to push the Docker image to Docker Hub."
            exit 1
        fi
    fi
else
    echo "Failed to build the Docker image."
    exit 1
fi
